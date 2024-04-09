//
//  ImageCache.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/03/05.
//

import Foundation

enum CacheOption {
    case all
    case memory
    case disk
}

final class ImageCache: ImageCacheType {
    static let `default`: ImageCache = .init(memoryCountLimit: 30, diskCountLimit: 100, option: .all)
    
    private let memoryStorage: InMemoryCacheStorage<Image>
    
    private let diskStorage: OnDiskCacheStorage<Image>
    
    private let cacheOption: CacheOption
    
    init(
        memoryStorage: InMemoryCacheStorage<Image>,
        diskStorage: OnDiskCacheStorage<Image>,
        option: CacheOption
    ) {
        self.memoryStorage = memoryStorage
        self.diskStorage = diskStorage
        self.cacheOption = option
    }
    
    convenience init(
        memoryCountLimit: Int,
        diskCountLimit: Int,
        option: CacheOption
    ) {
        let memoryStorage = InMemoryCacheStorage<Image>(countLimit: memoryCountLimit)
        let diskStorage = OnDiskCacheStorage<Image>(
            fileManager: .default,
            countLimit: diskCountLimit,
            cacheExpiration: .days(7),
            creatingDirectory: true
        )
        self.init(memoryStorage: memoryStorage, diskStorage: diskStorage, option: option)
    }
    
    convenience init(
        memoryCountLimit: Int,
        diskCountLimit: Int,
        directoryPath: String
    ) throws {
        let memoryStorage = InMemoryCacheStorage<Image>(countLimit: memoryCountLimit)
        let diskStorage = try OnDiskCacheStorage<Image>(
            countLimit: diskCountLimit,
            directoryPath: directoryPath
        )
        self.init(memoryStorage: memoryStorage, diskStorage: diskStorage, option: .all)
    }
    
    func store(_ image: Image, for key: String, option: CacheOption?) throws {
        let option = option ?? cacheOption
        
        switch option {
        case .all:
            storeToMemory(image, for: key)
            try storeToDisk(image, for: key)
        case .memory:
            storeToMemory(image, for: key)
        case .disk:
            try storeToDisk(image, for: key)
        }
    }
    
    private func storeToMemory(_ image: Image, for key: String) {
        memoryStorage.store(image, for: key)
    }
    
    private func storeToDisk(_ image: Image, for key: String) throws {
        try diskStorage.store(value: image, for: key)
    }
    
    func retrieveImage(for key: String) throws -> Image? {
        if let image = retrieveImageInMemory(for: key) {
            return image
        }
        
        if let image = try retrieveImageOnDisk(for: key) {
            storeToMemory(image, for: key)
            return image
        }
        
        return nil
    }
    
    private func retrieveImageInMemory(for key: String) -> Image? {
        return memoryStorage.value(for: key)
    }
    
    private func retrieveImageOnDisk(for key: String) throws -> Image? {
        return try diskStorage.value(for: key)
    }
    
    func removeImage(for key: String, option: CacheOption?) throws {
        let option = option ?? cacheOption
        
        switch option {
        case .all:
            removeImageInMemory(for: key)
            try removeImageOnDisk(for: key)
        case .memory:
            removeImageInMemory(for: key)
        case .disk:
            try removeImageOnDisk(for: key)
        }
    }
    
    private func removeImageInMemory(for key: String) {
        memoryStorage.removeValue(for: key)
    }
    
    private func removeImageOnDisk(for key: String) throws {
        try diskStorage.removeValue(for: key)
    }
    
    func removeAll(option: CacheOption?) throws {
        let option = option ?? cacheOption
        
        switch option {
        case .all:
            removeAllInMemory()
            try removeAllOnDisk()
        case .memory:
            removeAllInMemory()
        case .disk:
            try removeAllOnDisk()
        }
    }
    
    private func removeAllInMemory() {
        memoryStorage.removeAll()
    }
    
    private func removeAllOnDisk() throws {
        try diskStorage.removeAll()
    }
    
    func removeExpired(option: CacheOption?) throws {
        let option = option ?? cacheOption
        
        switch option {
        case .all:
            removeExpiredInMemory()
            try removeExpiredOnDisk()
        case .memory:
            removeExpiredInMemory()
        case .disk:
            try removeExpiredOnDisk()
        }
    }
    
    private func removeExpiredInMemory() {
        memoryStorage.removeExpired()
    }
    
    private func removeExpiredOnDisk() throws {
        try diskStorage.removeExpired()
    }
    
    func isCached(for key: String) -> Bool {
        let isCachedInMemory = memoryStorage.isCached(for: key)
        let isCachedOnDisk = diskStorage.isCached(for: key)
        return isCachedInMemory || isCachedOnDisk
    }
}
