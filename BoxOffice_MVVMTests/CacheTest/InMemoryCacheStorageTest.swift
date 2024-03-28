//
//  InMemoryCacheStorageTest.swift
//  BoxOffice_MVVMTests
//
//  Created by Rowan on 2024/03/21.
//

import XCTest
@testable import BoxOffice_MVVM

class InMemoryCacheStorageTest: XCTestCase {
    var memoryStorage: InMemoryCacheStorage<Int>!
    
    override func setUp() {
        memoryStorage = .init(countLimit: 5)
    }
    
    override func tearDown() {
        memoryStorage = nil
    }
    
    func test_storeAndGetValue() {
        let key = "one"
        let value = 1
        XCTAssertFalse(memoryStorage.isCached(for: key))
        XCTAssertNil(memoryStorage.value(for: key))
        
        memoryStorage.store(value, for: key)
        
        XCTAssertTrue(memoryStorage.isCached(for: key))
        XCTAssertEqual(memoryStorage.value(for: key), value)
    }
    
    func test_storeValueOverwrite() {
        let key = "one"
        let value = 1
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
        memoryStorage.store(firstValue, for: firstKey, expiration: 0.5)
        memoryStorage.store(secondValue, for: secondKey, expiration: 3)
        
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
    
    func test_getValueWithExtendingExpiration() {
        let stillCachedExpectation = expectation(description: "getValueWithExtendingExpiration Still Cached Expectation")
        let extendedExpirationExpectation = expectation(description: "getValueWithExtendingExpiration Extended Expiration Expectation")
        
        let key = "one"
        let value = 1
        XCTAssertFalse(memoryStorage.isCached(for: key))
        memoryStorage.store(value, for: key, expiration: 0.2)
        XCTAssertTrue(memoryStorage.isCached(for: key))
        
        let cached = memoryStorage.value(for: key, extendingExpiration: .extend(second: 0.5))
        XCTAssertEqual(value, cached)
        
        delay(0.5) {
            XCTAssertTrue(self.memoryStorage.isCached(for: key))
            stillCachedExpectation.fulfill()
        }
        
        delay(0.8) {
            XCTAssertFalse(self.memoryStorage.isCached(for: key))
            extendedExpirationExpectation.fulfill()
        }
        
        wait(for: [stillCachedExpectation, extendedExpirationExpectation], timeout: 2)
    }
    
    func test_removeExpired() {
        let expectation = expectation(description: "removeExpired Expectation")
        
        let (firstKey, firstValue) = ("one", 1)
        let (secondKey, secondValue) = ("two", 2)
        memoryStorage.store(firstValue, for: firstKey, expiration: 0.2)
        memoryStorage.store(secondValue, for: secondKey, expiration: 5)
        XCTAssertTrue(memoryStorage.isCached(for: firstKey))
        XCTAssertTrue(memoryStorage.isCached(for: secondKey))
        
        delay(0.3) {
            self.memoryStorage.removeExpired()
            XCTAssertFalse(self.memoryStorage.isCached(for: firstKey))
            XCTAssertTrue(self.memoryStorage.isCached(for: secondKey))
            XCTAssertEqual(self.memoryStorage.value(for: secondKey), secondValue)
            XCTAssertNil(self.memoryStorage.value(for: firstKey))
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
}
