//
//  InMemoryCacheStorage.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/02/28.
//

import Foundation

final class InMemoryCacheStorage<T> {
    private let storage: NSCache<NSString, CacheObject<T>> = .init()
    private let lock: NSLock = .init()
    private var keys: Set<String> = []
    
    init(countLimit: Int) {
        storage.countLimit = countLimit
    }
    
    func store(_ value: T, for key: String) {
        lock.lock()
        defer { lock.unlock() }
        
        let now = Date()
        let expiration = TimeInterval(60 * 5)
        let estimatedExpiration = now.addingTimeInterval(expiration)
        let cacheObject = CacheObject(value: value,
                                      expiration: estimatedExpiration)
        storage.setObject(cacheObject, forKey: key as NSString)
        keys.insert(key)
    }
    
    func value(for key: String, extendingExpiration: Bool = true) -> T? {
        guard let cacheObject = storage.object(forKey: key as NSString)
        else { return nil }
        
        if cacheObject.isExpired { return nil }
        if extendingExpiration { cacheObject.extendExpiration() }
        
        return cacheObject.value
    }
    
    func removeExpired() {
        lock.lock()
        defer { lock.unlock() }
        
        for key in keys {
            let nsKey = key as NSString
            guard let cacheObject = storage.object(forKey: nsKey)
            else {
                keys.remove(key)
                continue
            }
            
            if cacheObject.isExpired {
                storage.removeObject(forKey: nsKey)
                keys.remove(key)
            }
        }
    }
    
    func removeValue(for key: String) {
        lock.lock()
        defer { lock.unlock() }
        storage.removeObject(forKey: key as NSString)
        keys.remove(key)
    }
    
    func removeAll() {
        lock.lock()
        defer { lock.unlock() }
        storage.removeAllObjects()
        keys.removeAll()
    }
    
    func isCached(for key: String) -> Bool {
        guard value(for: key, extendingExpiration: false) != nil else {
            return false
        }
        return true
    }
}

private extension InMemoryCacheStorage {
    final class CacheObject<T> {
        let value: T
        var expiration: Date
        
        init(value: T, expiration: Date) {
            self.value = value
            self.expiration = expiration
        }
        
        var isExpired: Bool {
            expiration.isPast(referenceDate: Date())
        }
        
        func extendExpiration() {
            let extendingExpiration = TimeInterval(60 * 5)
            self.expiration = expiration.addingTimeInterval(extendingExpiration)
        }
    }
}
