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
    
    private var cleanTimer: Timer? = nil
    
    private var keys: Set<String> = []
    
    init(countLimit: Int, cleanInterval: TimeInterval = 180) {
        storage.countLimit = countLimit
        
        cleanTimer = .scheduledTimer(
            withTimeInterval: cleanInterval,
            repeats: true,
            block: { [weak self] _ in
                guard let self else { return }
                self.removeExpired()
            }
        )
    }
    
    func store(_ value: T, for key: String, expiration: TimeInterval = 300) {
        lock.lock()
        defer { lock.unlock() }
        
        let now = Date()
        let estimatedExpiration = now.addingTimeInterval(expiration)
        let cacheObject = CacheObject(value: value,
                                      expiration: estimatedExpiration)
        storage.setObject(cacheObject, forKey: key as NSString)
        keys.insert(key)
    }
    
    func value(for key: String, extendingExpiration: ExpirationExtending = .extend(second: 180)) -> T? {
        guard let cacheObject = storage.object(forKey: key as NSString)
        else { return nil }
        
        if cacheObject.isExpired { return nil }
        cacheObject.extendExpiration(extendingExpiration)
        
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
        guard value(for: key, extendingExpiration: .none) != nil else {
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
        
        func extendExpiration(_ extending: ExpirationExtending) {
            switch extending {
            case let .extend(second):
                self.expiration = expiration.addingTimeInterval(second)
            case .none:
                return
            }
        }
    }
}
