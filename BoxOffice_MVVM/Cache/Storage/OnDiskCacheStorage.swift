//
//  OnDiskCacheStorage.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/03/01.
//

import Foundation

enum OnDiskCacheError: Error {
    case cannotCreateDirectory(error: Error)
    case storageNotReady
    case cannotCreateFile(error: Error)
    case cannotFindValue(error: Error)
}

final class OnDiskCacheStorage {
    private let storage: FileManager
    
    private let directoryURL: URL
    
    private var isStorageReady: Bool = true
    
    init(storage: FileManager = .default) {
        self.storage = storage
        self.directoryURL = storage.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        try? prepareDirectory()
    }
    
    private func prepareDirectory() throws {
        let path = directoryURL.path
        
        guard !storage.fileExists(atPath: path) else { return }
        
        do {
            try storage.createDirectory(
                atPath: path,
                withIntermediateDirectories: true
            )
        } catch {
            isStorageReady = false
            throw OnDiskCacheError.cannotCreateDirectory(error: error)
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
            throw OnDiskCacheError.cannotCreateFile(error: error)
        }
    }
    
    func value(for key: String) throws -> Data {
        let filePath = directoryURL.appending(path: key)
        do {
            let value = try Data(contentsOf: filePath)
            return value
        } catch {
            throw OnDiskCacheError.cannotFindValue(error: error)
        }
    }
}
