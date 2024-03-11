//
//  ImageCache.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/03/05.
//

import Foundation
import UIKit.UIImage

typealias Image = UIImage

enum CacheOption {
    case all
    case memory
    case disk
    case none
}

enum ImageCacheError: Error {
    case cannotSerializeImage
    case expiredImage(key: String)
}

final class ImageCache: ImageCacheType {
    static let `default`: ImageCache = .init(memoryCacheLimit: 30, diskCacheLimit: 100)
    
    private let memoryStorage: InMemoryCacheStorage<Image>
    private let diskStorage: OnDiskCacheStorage
    
    convenience init(memoryCacheLimit: Int, diskCacheLimit: Int) {
        self.init(
            memoryStorage: .init(countLimit: memoryCacheLimit),
            diskStorage: .init(countLimit: diskCacheLimit)
        )
    }
    
    init(
        memoryStorage: InMemoryCacheStorage<Image>,
        diskStorage: OnDiskCacheStorage
    ) {
        self.memoryStorage = memoryStorage
        self.diskStorage = diskStorage
    }
    
    func store(_ image: Image, for key: String, option: CacheOption) throws {
        switch option {
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
        guard let imageData = image.jpegData(compressionQuality: 1.0)
        else { throw ImageCacheError.cannotSerializeImage }
        try diskStorage.store(value: imageData, for: key)
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
        guard let imageData = try diskStorage.value(for: key)
        else { throw ImageCacheError.expiredImage(key: key) }
        return Image(data: imageData)
    }
    
    func isCached(for key: String) throws -> Bool {
        let isCachedInMemory = memoryStorage.isCached(for: key)
        let isCachedOnDisk = try diskStorage.isCached(for: key)
        return isCachedInMemory || isCachedOnDisk
    }
}
