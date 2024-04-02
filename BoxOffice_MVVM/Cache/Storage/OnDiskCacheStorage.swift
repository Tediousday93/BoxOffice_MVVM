//
//  OnDiskCacheStorage.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/03/01.
//

import Foundation

enum OnDiskCacheError: Error, Equatable {
    case cannotCreateDirectory(path: String, error: Error)
    
    case storageNotReady
    
    case cannotCreateFile(url: URL, error: Error)
    
    case cannotSetFileAttributes(filePath: String, attributes: [FileAttributeKey: Any], error: Error)
    
    case invalidURLResource(keys: Set<URLResourceKey>, url: URL, error: Error)
    
    case expirationNotContained(url: URL)
    
    case cannotRemoveFile(url: URL, error: Error)
    
    case cannotFindValue(url: URL, error: Error)
    
    case directoryEnumeratorCreationFail(url: URL)
    
    case invalidURLContained(url: URL)
    
    static func == (lhs: OnDiskCacheError, rhs: OnDiskCacheError) -> Bool {
        switch (lhs, rhs) {
        case (.cannotCreateDirectory, .cannotCreateDirectory),
            (.storageNotReady, .storageNotReady),
            (.cannotCreateFile, .cannotCreateFile),
            (.cannotSetFileAttributes, .cannotSetFileAttributes),
            (.invalidURLResource, .invalidURLResource),
            (.expirationNotContained, .expirationNotContained),
            (.cannotFindValue, .cannotFindValue),
            (.directoryEnumeratorCreationFail, .directoryEnumeratorCreationFail),
            (.invalidURLContained, .invalidURLContained):
            return true
        default:
            return false
        }
    }
}

final class OnDiskCacheStorage<T: DataConvertible> {
    private let fileManager: FileManager
    
    private let directoryURL: URL
    
    private var isStorageReady: Bool = true
    
    private let countLimit: Int
    
    init(
        fileManager: FileManager = .default,
        countLimit: Int,
        creatingDirectory: Bool
    ) {
        self.fileManager = fileManager
        self.directoryURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        self.countLimit = countLimit
        
        if creatingDirectory {
            try? prepareDirectory()
        }
    }
    
    convenience init(countLimit: Int) throws {
        self.init(fileManager: .default, countLimit: countLimit, creatingDirectory: false)
        try prepareDirectory()
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
    
    func store(value: T, for key: String, expiration: CacheExpiration = .days(7)) throws {
        guard isStorageReady else {
            throw OnDiskCacheError.storageNotReady
        }
        
        if let limitExceedings = try exceedingCountLimitFileURLs() {
            try limitExceedings.forEach { fileURL in
                try removeData(at: fileURL)
            }
        }
        
        let fileURL = directoryURL.appending(path: key)
        let data = try value.toData()
        
        do {
            try data.write(to: fileURL)
        } catch {
            throw OnDiskCacheError.cannotCreateFile(url: fileURL, error: error)
        }
        
        let now = Date.now
        let estimatedExpiration = expiration.estimatedExpirationSince(now)
        let attributes: [FileAttributeKey: Any] = [
            .creationDate: now as NSDate,
            .modificationDate: estimatedExpiration as NSDate
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
    
    private func exceedingCountLimitFileURLs() throws -> [URL]? {
        let urls = try allFileURLs(for: [.creationDateKey, .contentModificationDateKey])
        let exceedingCount = urls.count - countLimit
        
        if exceedingCount <= 0 { return nil }
        
        let resourceKeys: Set<URLResourceKey> = [.creationDateKey, .contentModificationDateKey]
        var sortedFileURLs = try urls.sorted { leftURL, rightURL in
            guard let leftExpiration = try resourceValues(for: resourceKeys, at: leftURL).contentModificationDate
            else { throw OnDiskCacheError.expirationNotContained(url: leftURL) }
            
            guard let rightExpiration = try resourceValues(for: resourceKeys, at: rightURL).contentModificationDate
            else { throw OnDiskCacheError.expirationNotContained(url: rightURL) }
            
            return rightExpiration.isPast(referenceDate: leftExpiration)
        }
        
        var exceedingFileURLs: [URL] = []
        for _ in 0...exceedingCount {
            exceedingFileURLs.append(sortedFileURLs.removeLast())
        }
        
        return exceedingFileURLs
    }
    
    private func allFileURLs(for resourceKeys: [URLResourceKey]) throws -> [URL] {
        guard let directoryEnumerator = fileManager.enumerator(
            at: directoryURL,
            includingPropertiesForKeys: resourceKeys,
            options: .skipsHiddenFiles
        ) else {
            throw OnDiskCacheError.directoryEnumeratorCreationFail(url: directoryURL)
        }
        
        guard let fileURLs = directoryEnumerator.allObjects as? [URL]
        else {
            throw OnDiskCacheError.invalidURLContained(url: directoryURL)
        }
        
        return fileURLs
    }
    
    private func resourceValues(
        for keys: Set<URLResourceKey>,
        at url: URL
    ) throws -> URLResourceValues {
        let urlResourceValues: URLResourceValues
        
        do {
            urlResourceValues = try url.resourceValues(forKeys: keys)
        } catch {
            throw OnDiskCacheError.invalidURLResource(
                keys: keys, url: url, error: error
            )
        }
        
        return urlResourceValues
    }
    
    func value(
        for key: String,
        extendingExpiration: ExpirationExtending = .cacheTime
    ) throws -> T? {
        return try data(
            for: key,
            actuallyLoad: true,
            extendingExpiration: extendingExpiration
        )
    }
    
    private func data(
        for key: String,
        actuallyLoad: Bool,
        extendingExpiration: ExpirationExtending
    ) throws -> T? {
        guard isStorageReady else {
            throw OnDiskCacheError.storageNotReady
        }
        
        let fileURL = directoryURL.appending(path: key)
        
        guard fileManager.fileExists(atPath: fileURL.path) else {
            return nil
        }
        
        let resourceKeys: Set<URLResourceKey> = [.creationDateKey, .contentModificationDateKey]
        let urlResourceValues = try resourceValues(for: resourceKeys, at: fileURL)
        let isExpired = urlResourceValues.contentModificationDate?
            .isPast(referenceDate: Date()) ?? true
        
        if isExpired { return nil }
        if !actuallyLoad { return T.empty }
        
        do {
            let data = try Data(contentsOf: fileURL)
            extendExpiration(
                filePath: fileURL.path,
                lastAccessDate: urlResourceValues.creationDate,
                lastEstimatedExpirationDate: urlResourceValues.contentModificationDate,
                extendingExpiration: extendingExpiration
            )
            return try T.fromData(data)
        } catch {
            throw OnDiskCacheError.cannotFindValue(url: fileURL, error: error)
        }
    }
    
    private func extendExpiration(
        filePath: String,
        lastAccessDate: Date?,
        lastEstimatedExpirationDate: Date?,
        extendingExpiration: ExpirationExtending
    ) {
        guard let lastAccessDate, let lastEstimatedExpirationDate else {
            return
        }
        
        let accessDate = Date()
        let expirationDate: Date
        
        switch extendingExpiration {
        case .cacheTime:
            let origianlExpiration: CacheExpiration = .seconds(
                lastEstimatedExpirationDate.timeIntervalSince(lastAccessDate)
            )
            expirationDate = origianlExpiration.estimatedExpirationSince(accessDate)
        case let .newExpiration(expiration):
            expirationDate = expiration.estimatedExpirationSince(accessDate)
        case .none:
            return
        }
        
        let attributes: [FileAttributeKey: Any] = [
            .creationDate: accessDate as NSDate,
            .modificationDate: expirationDate as NSDate
        ]
        
        try? fileManager.setAttributes(attributes, ofItemAtPath: filePath)
    }
    
    func removeValue(for key: String) throws {
        let fileURL = directoryURL.appending(path: key)
        try removeData(at: fileURL)
    }
    
    func removeAll() throws {
        try removeData(at: directoryURL)
        try prepareDirectory()
    }
    
    func removeExpired() throws {
        let fileURLs = try allFileURLs(for: [.creationDateKey, .contentModificationDateKey])
        
        guard fileURLs.count > 0 else { return }
        
        let resourceKeys: Set<URLResourceKey> = [.creationDateKey, .contentModificationDateKey]
        let expiredFileURLs = fileURLs.filter { fileURL in
            let resourceValues: URLResourceValues
            do {
                resourceValues = try fileURL.resourceValues(forKeys: resourceKeys)
            } catch {
                return true
            }
            
            return resourceValues.contentModificationDate?.isPast(referenceDate: Date()) ?? true
        }
        
        try expiredFileURLs.forEach { fileURL in
            try removeData(at: fileURL)
        }
    }
    
    private func removeData(at url: URL) throws {
        do {
            try fileManager.removeItem(at: url)
        } catch {
            throw OnDiskCacheError.cannotRemoveFile(url: url, error: error)
        }
    }
    
    func isCached(for key: String) -> Bool {
        let result = try? data(for: key, actuallyLoad: false, extendingExpiration: .none)
        return result != nil
    }
}
