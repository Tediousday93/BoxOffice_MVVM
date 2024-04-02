//
//  ImageCache.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/03/05.
//

import Foundation
import UIKit.UIImage

typealias Image = UIImage
extension Image: DataConvertible {
    func toData() throws -> Data {
        guard let data = jpegData(compressionQuality: 1.0)
        else { throw DataConvertError.cannotConvertToData }
        return data
    }
    
    static func fromData(_ data: Data) throws -> Self {
        guard let image = Image(data: data) as? Self
        else { throw DataConvertError.cannotConvertFromData }
        return image
    }
    
    static var empty: Self { Self() }
}

final class ImageCache: ImageCacheType {
    static let `default`: ImageCache = .init(noThrowMemoryCacheLimit: 30, diskCacheLimit: 100, option: .all)
    
    private let memoryStorage: InMemoryCacheStorage<Image>
    
    private let diskStorage: OnDiskCacheStorage<Image>
    
    private let cacheOption: CacheOption
    
    convenience init(
        memoryCacheLimit: Int,
        diskCacheLimit: Int,
        option: CacheOption
    ) throws {
        self.init(
            memoryStorage: .init(countLimit: memoryCacheLimit),
            diskStorage: try .init(countLimit: diskCacheLimit),
            option: option
        )
    }
    
    convenience init(
        noThrowMemoryCacheLimit: Int,
        diskCacheLimit: Int,
        option: CacheOption
    ) {
        let memoryStorage = InMemoryCacheStorage<Image>.init(countLimit: noThrowMemoryCacheLimit)
        let diskStorage = OnDiskCacheStorage<Image>.init(countLimit: diskCacheLimit, creatingDirectory: true)
        self.init(memoryStorage: memoryStorage, diskStorage: diskStorage, option: option)
    }
    
    init(
        memoryStorage: InMemoryCacheStorage<Image>,
        diskStorage: OnDiskCacheStorage<Image>,
        option: CacheOption
    ) {
        self.memoryStorage = memoryStorage
        self.diskStorage = diskStorage
        self.cacheOption = option
    }
    
    func store(_ image: Image, for key: String) throws {
        switch cacheOption {
        case .all:
            storeToMemory(image, for: key)
            try storeToDisk(image, for: key)
        case .memory:
            storeToMemory(image, for: key)
        case .disk:
            try storeToDisk(image, for: key)
        case .none:
            return
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
        
        if let image = try retrieveImageInDisk(for: key) {
            storeToMemory(image, for: key)
            return image
        }
        
        return nil
    }
    
    private func retrieveImageInMemory(for key: String) -> Image? {
        return memoryStorage.value(for: key)
    }
    
    private func retrieveImageInDisk(for key: String) throws -> Image? {
        return try diskStorage.value(for: key)
    }
    
    func isCached(for key: String) throws -> Bool {
        let isCachedInMemory = memoryStorage.isCached(for: key)
        let isCachedOnDisk = diskStorage.isCached(for: key)
        return isCachedInMemory || isCachedOnDisk
    }
}

extension ImageCache {
    enum CacheOption {
        case all
        case memory
        case disk
        case none
    }
}
