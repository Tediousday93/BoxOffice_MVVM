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
        diskStorage = try .init(countLimit: 5)
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
}
