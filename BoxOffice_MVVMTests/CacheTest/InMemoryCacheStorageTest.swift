//
//  InMemoryCacheStorageTest.swift
//  BoxOffice_MVVMTests
//
//  Created by Rowan on 2024/03/21.
//

import XCTest
@testable import BoxOffice_MVVM

class InMemoryCacheStorageTest: XCTestCase {
    typealias TestCacheObject = InMemoryCacheStorage<Int>.CacheObject<Int>
    
    var innerStorage: NSCache<NSString, TestCacheObject>!
    var memoryStorage: InMemoryCacheStorage<Int>!
    
    override func setUp() {
        innerStorage = .init()
        innerStorage.countLimit = 3
        
        memoryStorage = .init(storage: innerStorage, cleanInterval: 2)
    }
    
    override func tearDown() {
        innerStorage = nil
        memoryStorage = nil
    }
    
    func test_storeAndGetValue() {
        let (key, value) = ("one", 1)
        XCTAssertFalse(memoryStorage.isCached(for: key))
        XCTAssertNil(memoryStorage.value(for: key))
        
        memoryStorage.store(value, for: key)
        
        XCTAssertTrue(memoryStorage.isCached(for: key))
        XCTAssertEqual(memoryStorage.value(for: key), value)
    }
    
    func test_storeValueOverwrite() {
        let (key, value) = ("one", 1)
        let overwriteValue = 2
        memoryStorage.store(value, for: key)
        XCTAssertEqual(memoryStorage.value(for: key), value)
        
        memoryStorage.store(overwriteValue, for: key)
        XCTAssertEqual(memoryStorage.value(for: key), overwriteValue)
    }
    
    func test_storeWithExpiration() {
        let expectation = expectation(description: "storeWithExpiration Expectation")
        
        let (firstKey, firstValue) = ("one", 1)
        let (secondKey, secondValue) = ("three", 3)
        memoryStorage.store(firstValue, for: firstKey, expiration: .seconds(0.5))
        memoryStorage.store(secondValue, for: secondKey, expiration: .seconds(3))
        
        XCTAssertTrue(memoryStorage.isCached(for: firstKey))
        XCTAssertTrue(memoryStorage.isCached(for: secondKey))
        
        delay(0.5) {
            XCTAssertFalse(self.memoryStorage.isCached(for: firstKey))
            XCTAssertNil(self.memoryStorage.value(for: firstKey))
            
            XCTAssertTrue(self.memoryStorage.isCached(for: secondKey))
            let notExpired = self.memoryStorage.value(for: secondKey)
            XCTAssertNotNil(notExpired)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_storeExceedingCountLimit() {
        memoryStorage.store(1, for: "1")
        memoryStorage.store(2, for: "2")
        memoryStorage.store(3, for: "3")
        memoryStorage.store(4, for: "4")
        
        XCTAssertFalse(memoryStorage.isCached(for: "1"))
        XCTAssertTrue(memoryStorage.isCached(for: "2"))
        XCTAssertTrue(memoryStorage.isCached(for: "3"))
        XCTAssertTrue(memoryStorage.isCached(for: "4"))
    }
    
    func test_getValueWithExtendingCacheTime() {
        let cachedExpectation = expectation(description: "getValueWithExtendingCacheTime cached Expectation")
        let expiredExpectation = expectation(description: "getValueWithExtendingCacheTime extended Expectation")
        
        let (key, value) = ("one", 1)
        XCTAssertFalse(memoryStorage.isCached(for: key))
        memoryStorage.store(value, for: key, expiration: .seconds(0.3))
        XCTAssertTrue(memoryStorage.isCached(for: key))
        
        guard let cacheObject = innerStorage.object(forKey: key as NSString)
        else {
            XCTFail("CacheObject must not be nil")
            return
        }
        
        let expectedExpiration = CacheExpiration.seconds(0.3)
            .estimatedExpirationSince(cacheObject.estimatedExpiration)
        
        _ = memoryStorage.value(for: key, extendingExpiration: .cacheTime)
        XCTAssertEqual(expectedExpiration, cacheObject.estimatedExpiration)
        
        delay(0.3) {
            XCTAssertTrue(self.memoryStorage.isCached(for: key))
            cachedExpectation.fulfill()
        }
        
        delay(0.7) {
            XCTAssertFalse(self.memoryStorage.isCached(for: key))
            expiredExpectation.fulfill()
        }
        
        wait(for: [cachedExpectation, expiredExpectation], timeout: 2)
    }
    
    func test_getValueWithExtendingNewExpiration() {
        let cachedExpectation = expectation(description: "getValueWithExtendingExpiration cached Expectation")
        let extendedExpectation = expectation(description: "getValueWithExtendingExpiration extended  Expectation")
        
        let (key, value) = ("one", 1)
        XCTAssertFalse(memoryStorage.isCached(for: key))
        memoryStorage.store(value, for: key, expiration: .seconds(0.2))
        XCTAssertTrue(memoryStorage.isCached(for: key))
        
        guard let cacheObject = self.innerStorage.object(forKey: key as NSString)
        else {
            XCTFail("CacheObject must not be nil")
            return
        }
        
        let beforeDate = cacheObject.estimatedExpiration
        let newExpiration = CacheExpiration.seconds(0.7)
            .estimatedExpirationSince(.now)
            .formatted(date: .complete, time: .omitted)
        _ = memoryStorage.value(for: key, extendingExpiration: .newExpiration(.seconds(0.7)))
        let afterDate = cacheObject.estimatedExpiration
        XCTAssertNotEqual(beforeDate, afterDate)
        XCTAssertEqual(newExpiration, cacheObject.estimatedExpiration.formatted(date: .complete
                                                                                , time: .omitted))
        
        delay(0.5) {
            XCTAssertTrue(self.memoryStorage.isCached(for: key))
            cachedExpectation.fulfill()
        }
        
        delay(0.8) {
            XCTAssertFalse(self.memoryStorage.isCached(for: key))
            extendedExpectation.fulfill()
        }
        
        wait(for: [cachedExpectation, extendedExpectation], timeout: 2)
    }
    
    func test_getValueNotExtendingExpiration() {
        let (key, value) = ("one", 1)
        XCTAssertFalse(memoryStorage.isCached(for: key))
        memoryStorage.store(value, for: key)
        XCTAssertTrue(memoryStorage.isCached(for: key))
        
        guard let cacheObject = innerStorage.object(forKey: key as NSString)
        else {
            XCTFail("CacheObject must not be nil")
            return
        }
        
        let beforeDate = cacheObject.estimatedExpiration
        _ = memoryStorage.value(for: key, extendingExpiration: .none)
        let afterDate = cacheObject.estimatedExpiration
        
        XCTAssertEqual(beforeDate, afterDate)
    }
    
    func test_removeExpired() {
        let expectation = expectation(description: "removeExpired Expectation")
        
        let (firstKey, firstValue) = ("one", 1)
        let (secondKey, secondValue) = ("two", 2)
        memoryStorage.store(firstValue, for: firstKey, expiration: .seconds(0.2))
        memoryStorage.store(secondValue, for: secondKey, expiration: .seconds(5))
        XCTAssertTrue(memoryStorage.isCached(for: firstKey))
        XCTAssertTrue(memoryStorage.isCached(for: secondKey))
        
        delay(0.3) {
            self.memoryStorage.removeExpired()
            
            XCTAssertFalse(self.memoryStorage.isCached(for: firstKey))
            XCTAssertNil(self.memoryStorage.value(for: firstKey))
            XCTAssertTrue(self.memoryStorage.isCached(for: secondKey))
            XCTAssertEqual(self.memoryStorage.value(for: secondKey), secondValue)
            
            XCTAssertNil(self.innerStorage.object(forKey: firstKey as NSString))
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_autoClean() {
        let expectation = expectation(description: "autoRemoveExpired Expectation")
        
        let (firstKey, firstValue) = ("one", 1)
        let (secondKey, secondValue) = ("ten", 10)
        memoryStorage.store(firstValue, for: firstKey, expiration: .seconds(1))
        memoryStorage.store(secondValue, for: secondKey, expiration: .seconds(10))
        XCTAssertTrue(memoryStorage.isCached(for: firstKey))
        XCTAssertTrue(memoryStorage.isCached(for: secondKey))
        
        delay(2) {
            XCTAssertFalse(self.memoryStorage.isCached(for: firstKey))
            XCTAssertTrue(self.memoryStorage.isCached(for: secondKey))
            XCTAssertNil(self.innerStorage.object(forKey: firstKey as NSString))
            
            let cachedObject = self.innerStorage.object(forKey: secondKey as NSString)
            XCTAssertNotNil(cachedObject)
            XCTAssertEqual(cachedObject!.value, secondValue)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
    }
    
    func test_removeValue() {
        let (key, value) = ("one", 1)
        XCTAssertFalse(memoryStorage.isCached(for: key))
        memoryStorage.store(value, for: key)
        XCTAssertTrue(memoryStorage.isCached(for: key))
        
        memoryStorage.removeValue(for: key)
        XCTAssertFalse(memoryStorage.isCached(for: key))
        XCTAssertNil(innerStorage.object(forKey: key as NSString))
    }
    
    func test_removeAll() {
        memoryStorage.store(1, for: "one")
        memoryStorage.store(2, for: "two")
        memoryStorage.store(3, for: "three")
        XCTAssertTrue(memoryStorage.isCached(for: "one"))
        XCTAssertTrue(memoryStorage.isCached(for: "two"))
        XCTAssertTrue(memoryStorage.isCached(for: "three"))
        
        memoryStorage.removeAll()
        XCTAssertFalse(memoryStorage.isCached(for: "one"))
        XCTAssertFalse(memoryStorage.isCached(for: "two"))
        XCTAssertFalse(memoryStorage.isCached(for: "three"))
        XCTAssertNil(innerStorage.object(forKey: "one" as NSString))
        XCTAssertNil(innerStorage.object(forKey: "two" as NSString))
        XCTAssertNil(innerStorage.object(forKey: "three" as NSString))
    }
    
    func test_cacheObject() {
        let expectation = expectation(description: "cacheObject Expectation")
        
        let cacheObject = TestCacheObject(value: 3, expiration: .seconds(0.5))
        XCTAssertEqual(cacheObject.value, 3)
        XCTAssertEqual(cacheObject.expiration, .seconds(0.5))
        XCTAssertFalse(cacheObject.isExpired)
        
        delay(0.5) {
            XCTAssertTrue(cacheObject.isExpired)
            
            let originalExpiration = cacheObject.expiration
            let expectedExpiration = cacheObject.expiration
                .estimatedExpirationSince(.now)
                .formatted(date: .complete, time: .omitted)
            
            cacheObject.extendExpiration(.cacheTime)
            
            XCTAssertFalse(cacheObject.isExpired)
            // 만료기간을 cacheTime으로 연장할 경우 초기 설정된 expiration 값만큼 연장된다.
            XCTAssertEqual(originalExpiration, .seconds(0.5))
            XCTAssertEqual(expectedExpiration, cacheObject.estimatedExpiration.formatted(date: .complete, time: .omitted))
            
            let newExpiration = CacheExpiration.seconds(0.2)
                .estimatedExpirationSince(.now)
                .formatted(date: .complete, time: .omitted)
            cacheObject.extendExpiration(.newExpiration(.seconds(0.2)))
            
            XCTAssertFalse(cacheObject.isExpired)
            // 만료기간을 직접 설정할 때는 초기에 설정된 expiration은 변경되지 않는다.
            XCTAssertEqual(cacheObject.expiration, .seconds(0.5))
            XCTAssertEqual(newExpiration, cacheObject.estimatedExpiration.formatted(date: .complete, time: .omitted))
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
}
