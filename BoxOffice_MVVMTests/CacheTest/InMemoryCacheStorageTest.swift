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
}
