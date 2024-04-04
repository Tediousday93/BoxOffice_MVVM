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
    let innerStorage = FileManager.default
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
}
