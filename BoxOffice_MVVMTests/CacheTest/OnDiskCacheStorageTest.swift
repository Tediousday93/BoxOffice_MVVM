//
//  OnDiskCacheStorageTest.swift
//  BoxOffice_MVVMTests
//
//  Created by Rowan on 2024/04/01.
//

import XCTest
@testable import BoxOffice_MVVM

extension String: DataConvertible {
    public func toData() throws -> Data {
        return data(using: .utf8)!
    }
    
    public static func fromData(_ data: Data) throws -> String {
        return String(data: data, encoding: .utf8)!
    }
    
    public static var empty: String {
        return ""
    }
}

class OnDiskCacheStorageTest: XCTestCase {
    typealias FileMeta = OnDiskCacheStorage<String>.FileMeta
    
    let innerStorage = FileManager.default
    let directoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    
    var diskStorage: OnDiskCacheStorage<String>!
    
    override func setUpWithError() throws {
        diskStorage = try .init(countLimit: 3, cacheExpiration: .seconds(5))
    }
    
    override func tearDownWithError() throws {
        try diskStorage.removeAll()
        diskStorage = nil
    }
    
    func test_storeAndGetValue() {
        let (key, value) = ("1", "1")
        
        XCTAssertFalse(diskStorage.isCached(for: key))
        var cached = try! diskStorage.value(for: key)
        XCTAssertNil(cached)
        
        try! diskStorage.store(value: value, for: key)
        XCTAssertTrue(diskStorage.isCached(for: key))
        
        cached = try! diskStorage.value(for: key)
        XCTAssertEqual(cached, value)
    }
    
    func test_storeValueOverwrite() {
        let (key, value) = ("1", "1")
        let overwriteValue = "one"
        
        try! diskStorage.store(value: value, for: key)
        var cached = try! diskStorage.value(for: key)
        XCTAssertEqual(cached, "1")
        
        try! diskStorage.store(value: overwriteValue, for: key)
        cached = try! diskStorage.value(for: key)
        XCTAssertEqual(cached, overwriteValue)
    }
    
    func test_storeWithExpiration() {
        let expectation = expectation(description: "storeWithExpiration Expectation")
        let (firstKey, firstValue) = ("1", "1")
        let (secondKey, secondValue) = ("2", "2")
        
        try! diskStorage.store(value: firstValue, for: firstKey, expiration: .seconds(0.5))
        try! diskStorage.store(value: secondValue, for: secondKey, expiration: .seconds(1))
        XCTAssertTrue(diskStorage.isCached(for: firstKey))
        XCTAssertTrue(diskStorage.isCached(for: secondKey))
        
        delay(0.5) {
            XCTAssertFalse(self.diskStorage.isCached(for: firstKey))
            let firstCached = try! self.diskStorage.value(for: firstKey)
            XCTAssertNil(firstCached)
            
            XCTAssertTrue(self.diskStorage.isCached(for: secondKey))
            let secondCached = try! self.diskStorage.value(for: secondKey)
            XCTAssertEqual(secondCached, secondValue)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_storeExceedingCountLimit() {
        try! diskStorage.store(value: "1", for: "1", expiration: .seconds(1))
        try! diskStorage.store(value: "2", for: "2", expiration: .seconds(5))
        try! diskStorage.store(value: "3", for: "3", expiration: .seconds(3))
        try! diskStorage.store(value: "4", for: "4", expiration: .seconds(4))
        try! diskStorage.store(value: "5", for: "5", expiration: .seconds(5))
        
        XCTAssertFalse(diskStorage.isCached(for: "1"))
        XCTAssertFalse(diskStorage.isCached(for: "3"))
        XCTAssertTrue(diskStorage.isCached(for: "2"))
        XCTAssertTrue(diskStorage.isCached(for: "4"))
        XCTAssertTrue(diskStorage.isCached(for: "5"))
    }
    
    func test_getValueWithExtendingCacheTime() {
        let cachedAndExtendingExpectation = expectation(description: "getValueWithExtendingCacheTime cached and extending Expectation")
        let extendedExpectation = expectation(description: "getValueWithExtendingCacheTime extended Expectation")
        let expiredExpectation = expectation(description: "getValueWithExtendingCacheTime expired Expectation")
        
        let (key, value) = ("1", "1")
        XCTAssertFalse(diskStorage.isCached(for: key))
        try! diskStorage.store(value: value, for: key, expiration: .seconds(1))
        XCTAssertTrue(diskStorage.isCached(for: key))
        
        delay(0.5) {
            XCTAssertTrue(self.diskStorage.isCached(for: key))
            // 만료기간이 1초로 저장되었으므로 0.5초 후 cacheTime으로 연장하면 그 차이인 0.5 만큼 늘어날 것.
            _ = try! self.diskStorage.value(for: key, extendingExpiration: .cacheTime)
            cachedAndExtendingExpectation.fulfill()
        }
        
        delay(1) {
            // 기존 만료기간 1초가 지났어도 정상적으로 연장되었으면 true
            XCTAssertTrue(self.diskStorage.isCached(for: key))
            extendedExpectation.fulfill()
        }
        
        delay(1.5) {
            // 늘어난 만료시간 만큼 시간이 경과했으므로 false
            XCTAssertFalse(self.diskStorage.isCached(for: key))
            expiredExpectation.fulfill()
        }
        
        let expectations = [
            cachedAndExtendingExpectation,
            extendedExpectation, expiredExpectation
        ]
        wait(for: expectations, timeout: 2)
    }
    
    func test_getValueWithExtendingNewExpiration() {
        let cachedExpectation = expectation(description: "getValueWithExtendingNewExpiration cached Expectation")
        let expiredExpectation = expectation(description: "getValueWithExtendingNewExpiration expired Expectation")
        
        let (key, value) = ("1", "1")
        XCTAssertFalse(diskStorage.isCached(for: key))
        try! diskStorage.store(value: value, for: key, expiration: .seconds(0.5))
        XCTAssertTrue(diskStorage.isCached(for: key))
        
        _ = try! diskStorage.value(for: key, extendingExpiration: .newExpiration(.seconds(1)))
        
        delay(0.5) {
            XCTAssertTrue(self.diskStorage.isCached(for: key))
            cachedExpectation.fulfill()
        }
        
        delay(1) {
            XCTAssertFalse(self.diskStorage.isCached(for: key))
            expiredExpectation.fulfill()
        }
        
        wait(for: [cachedExpectation, expiredExpectation], timeout: 2)
    }
    
    func test_removeValue() {
        let (key, value) = ("1", "1")
        XCTAssertFalse(diskStorage.isCached(for: key))
        try! diskStorage.store(value: value, for: key)
        XCTAssertTrue(diskStorage.isCached(for: key))
        
        try! diskStorage.removeValue(for: key)
        XCTAssertFalse(diskStorage.isCached(for: key))
        XCTAssertNil(try! diskStorage.value(for: key))
    }
    
    func test_removeAll() {
        try! diskStorage.store(value: "1", for: "1")
        try! diskStorage.store(value: "2", for: "2")
        try! diskStorage.store(value: "3", for: "3")
        XCTAssertTrue(diskStorage.isCached(for: "1"))
        XCTAssertTrue(diskStorage.isCached(for: "2"))
        XCTAssertTrue(diskStorage.isCached(for: "3"))
        
        try! diskStorage.removeAll()
        
        XCTAssertFalse(diskStorage.isCached(for: "1"))
        XCTAssertFalse(diskStorage.isCached(for: "2"))
        XCTAssertFalse(diskStorage.isCached(for: "3"))
        XCTAssertNil(try! diskStorage.value(for: "1"))
        XCTAssertNil(try! diskStorage.value(for: "2"))
        XCTAssertNil(try! diskStorage.value(for: "3"))
    }
    
    func test_removeExpired() {
        let expectation = expectation(description: "removeExpired Expectation")
        
        try! diskStorage.store(value: "1", for: "1", expiration: .seconds(0.5))
        try! diskStorage.store(value: "2", for: "2", expiration: .seconds(1))
        
        XCTAssertTrue(diskStorage.isCached(for: "1"))
        XCTAssertTrue(diskStorage.isCached(for: "2"))
        
        delay(0.7) {
            try! self.diskStorage.removeExpired()
            
            XCTAssertFalse(self.diskStorage.isCached(for: "1"))
            XCTAssertTrue(self.diskStorage.isCached(for: "2"))
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_FileMetaInit() {
        let cacheKey = "1"
        let value = "1"
        let expectedExpiration = CacheExpiration.seconds(1).estimatedExpirationSince(.now)
        let attributes: [FileAttributeKey: Any] = [
            .creationDate: Date.now,
            .modificationDate: expectedExpiration
        ]
        
        let fileURL = directoryURL.appending(path: cacheKey)
        let resourceKeys: Set<URLResourceKey> = [.creationDateKey, .contentModificationDateKey]
        
        XCTAssertThrowsError(try FileMeta(at: fileURL, resourceKeys: resourceKeys))
        
        try! value.toData().write(to: fileURL)
        try! innerStorage.setAttributes(attributes, ofItemAtPath: fileURL.path())
        
        XCTAssertNoThrow(try FileMeta(at: fileURL, resourceKeys: resourceKeys))
    }
}
