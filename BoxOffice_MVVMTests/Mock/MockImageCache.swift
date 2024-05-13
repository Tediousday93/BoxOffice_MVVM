//
//  MockImageCache.swift
//  BoxOffice_MVVMTests
//
//  Created by Rowan on 2024/04/10.
//

@testable import BoxOffice_MVVM

final class MockImageCache: ImageCacheType {
    var storage: [String: Image] = [:]
    var isCacheExpired: Bool = false
    var isCacheHit: Bool = false
    var removeExpiredCallCount: Int = .zero
    
    func store(_ image: Image, for key: String, option: CacheOption?) throws {
        storage[key] = image
    }
    
    func retrieveImage(for key: String) throws -> BoxOffice_MVVM.Image? {
        isCacheHit = true
        return storage[key]
    }
    
    func removeExpired(option: CacheOption?) throws {
        if isCacheExpired {
            storage.removeAll()
            isCacheExpired = false
        }
    }
    
    func isCached(for key: String) -> Bool {
        if isCacheExpired { return false }
        return storage[key] != nil
    }
}
