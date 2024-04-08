//
//  InMemoryCacheStorage.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/02/28.
//

import Foundation

final class InMemoryCacheStorage<T> {
    private let storage: NSCache<NSString, CacheObject<T>>
    
    private var cleanTimer: Timer? = nil
    
    private let cacheExpiration: CacheExpiration
    
    private let lock: NSLock = .init()
    
    private var keys: Set<String> = []
    
    init(
        storage: NSCache<NSString, CacheObject<T>>,
        cacheExpiration: CacheExpiration,
        cleanInterval: TimeInterval
    ) {
        self.storage = storage
        self.cacheExpiration = cacheExpiration
        cleanTimer = .scheduledTimer(
            withTimeInterval: cleanInterval,
            repeats: true,
            block: { [weak self] _ in
                guard let self else { return }
                self.removeExpired()
            }
        )
    }
    
    convenience init(
        countLimit: Int,
        cacheExpiration: CacheExpiration = .seconds(300),
        cleanInterval: TimeInterval = 180
    ) {
        self.init(storage: .init(),
                  cacheExpiration: cacheExpiration,
                  cleanInterval: cleanInterval)
        storage.countLimit = countLimit
    }
    
    func store(_ value: T, for key: String, expiration: CacheExpiration? = nil) {
        lock.lock()
        defer { lock.unlock() }
        
        let expiration = expiration ?? cacheExpiration
        let cacheObject = CacheObject(value: value,
                                      expiration: expiration)
        storage.setObject(cacheObject, forKey: key as NSString)
        keys.insert(key)
    }
    
    func value(
        for key: String,
        extendingExpiration: ExpirationExtending = .cacheTime
    ) -> T? {
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

extension InMemoryCacheStorage {
    final class CacheObject<T> {
        let value: T
        let expiration: CacheExpiration
        
        private(set) var estimatedExpiration: Date
        
        init(value: T, expiration: CacheExpiration) {
            self.value = value
            self.expiration = expiration
            self.estimatedExpiration = expiration.estimatedExpirationSince(.now)
        }
        
        var isExpired: Bool {
            estimatedExpiration.isPast(referenceDate: .now)
        }
        
        func extendExpiration(_ extending: ExpirationExtending) {
            switch extending {
            case .cacheTime:
                self.estimatedExpiration = expiration.estimatedExpirationSince(estimatedExpiration)
            case let .newExpiration(cacheExpiration):
                self.estimatedExpiration = cacheExpiration.estimatedExpirationSince(.now)
            case .none:
                return
            }
        }
    }
}
