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
    
    case cannotGetResourceValues(keys: Set<URLResourceKey>, url: URL, error: Error)
    
    case expirationNotContained(url: URL)
    
    case cannotRemoveFile(url: URL, error: Error)
    
    case cannotFindValue(url: URL, error: Error)
    
    case directoryEnumeratorCreationFail(url: URL)
    
    case invalidURLContained(url: URL)
}

final class OnDiskCacheStorage<T: DataConvertible> {
    private let fileManager: FileManager
    
    let directoryURL: URL
    
    let countLimit: Int
    
    let cacheExpiration: CacheExpiration
    
    private(set) var isStorageReady: Bool = true
    
    init(
        fileManager: FileManager,
        countLimit: Int,
        cacheExpiration: CacheExpiration,
        creatingDirectory: Bool,
        directoryURL: URL? = nil
    ) {
        self.fileManager = fileManager
        self.directoryURL = directoryURL ?? fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        self.countLimit = countLimit
        self.cacheExpiration = cacheExpiration
        
        if creatingDirectory {
            try? prepareDirectory()
        }
    }
    
    convenience init(
        countLimit: Int,
        cacheExpiration: CacheExpiration = .days(7),
        directoryPath: String? = nil
    ) throws {
        var directoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        if let directoryPath {
            directoryURL = directoryURL.appending(path: directoryPath, directoryHint: .isDirectory)
        }
        
        self.init(fileManager: .default,
                  countLimit: countLimit,
                  cacheExpiration: cacheExpiration,
                  creatingDirectory: false,
                  directoryURL: directoryURL)
        
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
    
    func store(value: T, for key: String, expiration: CacheExpiration? = nil) throws {
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
        
        let expiration = expiration ?? cacheExpiration
        let now = Date.now
        let estimatedExpiration = expiration.estimatedExpirationSince(now)
        let attributes: [FileAttributeKey: Any] = [
            .creationDate: now,
            .modificationDate: estimatedExpiration
        ]
        
        do {
            try fileManager.setAttributes(attributes, ofItemAtPath: fileURL.path())
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
        var sortedFileMeta = try urls.map { try FileMeta(at: $0, resourceKeys: resourceKeys) }
            .sorted { lhs, rhs in
                guard let leftExpiration = lhs.estimatedExpirationDate
                else { throw OnDiskCacheError.expirationNotContained(url: lhs.url) }
                
                guard let rightExpiration = rhs.estimatedExpirationDate
                else { throw OnDiskCacheError.expirationNotContained(url: rhs.url) }
                
                return rightExpiration.isPast(referenceDate: leftExpiration)
            }
        
        var exceedingFileURLs: [URL] = []
        for _ in 0...exceedingCount {
            exceedingFileURLs.append(sortedFileMeta.removeLast().url)
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
        let fileMeta = try FileMeta(at: fileURL, resourceKeys: resourceKeys)
        
        if fileMeta.isExpired { return nil }
        if !actuallyLoad { return T.empty }
        
        do {
            let data = try Data(contentsOf: fileURL)
            fileMeta.extendExpiration(
                with: fileManager,
                extendingExpiration: extendingExpiration
            )
            return try T.fromData(data)
        } catch {
            throw OnDiskCacheError.cannotFindValue(url: fileURL, error: error)
        }
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
            do {
                let fileMeta = try FileMeta(at: fileURL, resourceKeys: resourceKeys)
                return fileMeta.isExpired
            } catch {
                return true
            }
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

extension OnDiskCacheStorage {
    struct FileMeta {
        let url: URL
        let lastAccessDate: Date?
        let estimatedExpirationDate: Date?
        
        init(at url: URL, resourceKeys: Set<URLResourceKey>) throws {
            let resourceValues: URLResourceValues
            
            do {
                resourceValues = try url.resourceValues(forKeys: resourceKeys)
            } catch {
                throw OnDiskCacheError.cannotGetResourceValues(
                    keys: resourceKeys, url: url, error: error
                )
            }
            
            self.init(
                url: url,
                lastAccessDate: resourceValues.creationDate,
                estimatedExpirationDate: resourceValues.contentModificationDate
            )
        }
        
        init(
            url: URL,
            lastAccessDate: Date?,
            estimatedExpirationDate: Date?
        ) {
            self.url = url
            self.lastAccessDate = lastAccessDate
            self.estimatedExpirationDate = estimatedExpirationDate
        }
        
        var isExpired: Bool {
            estimatedExpirationDate?.isPast(referenceDate: .now) ?? true
        }
        
        func extendExpiration(
            with fileManager: FileManager,
            extendingExpiration: ExpirationExtending
        ) {
            guard let lastAccessDate, let estimatedExpirationDate else {
                return
            }
            
            let accessDate = Date.now
            let expirationDate: Date
            
            switch extendingExpiration {
            case .cacheTime:
                let origianlExpiration: CacheExpiration = .seconds(
                    estimatedExpirationDate.timeIntervalSince(lastAccessDate)
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
            
            try? fileManager.setAttributes(attributes, ofItemAtPath: url.path())
        }
    }
}
