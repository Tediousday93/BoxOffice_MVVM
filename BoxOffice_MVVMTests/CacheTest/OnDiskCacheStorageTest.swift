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
        do {
            XCTAssertFalse(diskStorage.isCached(for: key))
            XCTAssertNil(try diskStorage.value(for: key))
            
            try diskStorage.store(value: value, for: key)
            
            XCTAssertTrue(diskStorage.isCached(for: key))
            XCTAssertEqual(try diskStorage.value(for: key), value)
        } catch {
            XCTFail("Not Expected Error: \(error)")
        }
    }
    
    func test_storeValueOverwrite() {
        let (key, value) = ("1", "1")
        let overwriteValue = "one"
        
        do {
            try diskStorage.store(value: value, for: key)
            XCTAssertEqual(try diskStorage.value(for: key), "1")
            
            try diskStorage.store(value: overwriteValue, for: key)
            XCTAssertEqual(try diskStorage.value(for: key), overwriteValue)
        } catch {
            XCTFail("Not Expected Error: \(error)")
        }
    }
}
