//
//  OnDiskCacheStorage.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/03/01.
//

import Foundation

enum OnDiskCacheError: Error {
    case cannotCreateDirectory(path: String, error: Error)
    
    case storageNotReady
    
    case cannotCreateFile(url: URL, error: Error)
    
    case cannotSetFileAttributes(filePath: String, attributes: [FileAttributeKey: Any], error: Error)
    
    case invalidURLResource(keys: Set<URLResourceKey>, url: URL, error: Error)
    
    case cannotRemoveFile(url: URL, error: Error)
    
    case cannotFindValue(url: URL, error: Error)
}

final class OnDiskCacheStorage {
    private let fileManager: FileManager
    
    private let directoryURL: URL
    
    private var isStorageReady: Bool = true
    
    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
        self.directoryURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        try? prepareDirectory()
    }
    
    private func prepareDirectory() throws {
        let path = directoryURL.path
        
        guard !fileManager.fileExists(atPath: path) else { return }
        
        do {
            try fileManager.createDirectory(
                atPath: path,
                withIntermediateDirectories: true
            )
        } catch {
            isStorageReady = false
            throw OnDiskCacheError.cannotCreateDirectory(path: path, error: error)
        }
    }
    
    func store(value: Data, for key: String) throws {
        guard isStorageReady else {
            throw OnDiskCacheError.storageNotReady
        }
        
        let fileURL = directoryURL.appending(path: key)
        
        do {
            try value.write(to: fileURL)
        } catch {
            throw OnDiskCacheError.cannotCreateFile(url: fileURL, error: error)
        }
        
        let now = Date()
        let estimatedExpiration = TimeInterval(3600 * 24) * TimeInterval(7)
        let expirationDate = now.addingTimeInterval(estimatedExpiration)
        let attributes: [FileAttributeKey: Any] = [
            .creationDate: now as NSDate,
            .modificationDate: expirationDate as NSDate
        ]
        
        do {
            try fileManager.setAttributes(attributes, ofItemAtPath: fileURL.path)
        } catch {
            try? fileManager.removeItem(at: fileURL)
            throw OnDiskCacheError.cannotSetFileAttributes(
                filePath: fileURL.path,
                attributes: attributes,
                error: error
            )
        }
    }
    
    func value(for key: String) throws -> Data? {
        let fileURL = directoryURL.appending(path: key)
        
        guard fileManager.fileExists(atPath: fileURL.path) else {
            return nil
        }
        
        let resourceKeys: Set<URLResourceKey> = [.creationDateKey, .contentModificationDateKey]
        let urlResourceValues: URLResourceValues
        
        do {
            urlResourceValues = try fileURL.resourceValues(forKeys: resourceKeys)
        } catch {
            throw OnDiskCacheError.invalidURLResource(
                keys: resourceKeys, url: fileURL, error: error
            )
        }
        
        let isExpired = urlResourceValues.contentModificationDate?.isPast(referenceDate: Date()) ?? true
        
        if isExpired { return nil }
        
        do {
            let value = try Data(contentsOf: fileURL)
            extendExpiration(
                filePath: fileURL.path,
                lastAccessDate: urlResourceValues.creationDate,
                lastEstimatedExpirationDate: urlResourceValues.contentModificationDate
            )
            return value
        } catch {
            throw OnDiskCacheError.cannotFindValue(url: fileURL, error: error)
        }
    }
    
    func extendExpiration(filePath: String, lastAccessDate: Date?, lastEstimatedExpirationDate: Date?) {
        guard let lastAccessDate, let lastEstimatedExpirationDate else {
            return
        }
        
        let originalExpiration = lastEstimatedExpirationDate.timeIntervalSince(lastAccessDate)
        let expirationDate = Date().addingTimeInterval(originalExpiration)
        let attributes: [FileAttributeKey: Any] = [
            .creationDate: Date() as NSDate,
            .modificationDate: expirationDate as NSDate
        ]
        
        try? fileManager.setAttributes(attributes, ofItemAtPath: filePath)
    }
}

extension Date {
    func isPast(referenceDate: Date) -> Bool {
        self.timeIntervalSince(referenceDate) <= 0
    }
}
