//
//  ImageCacheTest.swift
//  BoxOffice_MVVMTests
//
//  Created by Rowan on 2024/04/08.
//

import XCTest
@testable import BoxOffice_MVVM

class ImageCacheTest: XCTestCase {
    let sampleImage = Image(data: MockData.sampleImageData)!
    
    var imageCache: ImageCache!
    var memoryStorage: InMemoryCacheStorage<Image>!
    var diskStorage: OnDiskCacheStorage<Image>!
    
    override func setUpWithError() throws {
        memoryStorage = .init(countLimit: 3,
                              cacheExpiration: .seconds(2),
                              cleanInterval: 1.5)
        
        diskStorage = try .init(countLimit: 3, cacheExpiration: .seconds(3))
        
        imageCache = .init(memoryStorage: memoryStorage,
                           diskStorage: diskStorage,
                           option: .all)
    }
    
    override func tearDownWithError() throws {
        try diskStorage.removeAll()
        memoryStorage = nil
        diskStorage = nil
        imageCache = nil
    }
    
    func test_storeWithNoOption() {
        let key = "sample"
        XCTAssertFalse(imageCache.isCached(for: key))
        try! imageCache.store(sampleImage, for: key)
        XCTAssertTrue(imageCache.isCached(for: key))
        XCTAssertTrue(diskStorage.isCached(for: key))
        XCTAssertTrue(diskStorage.isCached(for: key))
    }
    
    func test_storeToMemory() {
        let key = "sample"
        XCTAssertFalse(imageCache.isCached(for: key))
        try! imageCache.store(sampleImage, for: key, option: .memory)
        XCTAssertTrue(imageCache.isCached(for: key))
        XCTAssertTrue(memoryStorage.isCached(for: key))
        XCTAssertFalse(diskStorage.isCached(for: key))
    }
    
    func test_storeToDisk() {
        let key = "sample"
        XCTAssertFalse(imageCache.isCached(for: key))
        try! imageCache.store(sampleImage, for: key, option: .disk)
        XCTAssertTrue(imageCache.isCached(for: key))
        XCTAssertFalse(memoryStorage.isCached(for: key))
        XCTAssertTrue(diskStorage.isCached(for: key))
    }
    
    func test_retrieveImageFromMemory() {
        let key = "sample"
        XCTAssertFalse(imageCache.isCached(for: key))
        try! imageCache.store(sampleImage, for: key, option: .memory)
        XCTAssertTrue(memoryStorage.isCached(for: key))
        XCTAssertFalse(diskStorage.isCached(for: key))
        
        let cachedImage = try! imageCache.retrieveImage(for: key)
        XCTAssertNotNil(cachedImage)
        XCTAssertFalse(diskStorage.isCached(for: key))
    }
    
    func test_retrieveImageFromDisk() {
        let key = "sample"
        XCTAssertFalse(imageCache.isCached(for: key))
        try! imageCache.store(sampleImage, for: key, option: .disk)
        XCTAssertTrue(diskStorage.isCached(for: key))
        XCTAssertFalse(memoryStorage.isCached(for: key))
        
        let cachedImage = try! imageCache.retrieveImage(for: key)
        XCTAssertNotNil(cachedImage)
        XCTAssertTrue(memoryStorage.isCached(for: key))
    }
    
    func test_retrieveImageWithNotCachedKey() {
        XCTAssertNil(try! imageCache.retrieveImage(for: "sample"))
    }
    
    func test_removeImage() {
        let key = "sample"
        XCTAssertFalse(imageCache.isCached(for: key))
        try! imageCache.store(sampleImage, for: key, option: .all)
        
        try! imageCache.removeImage(for: key, option: .memory)
        XCTAssertFalse(memoryStorage.isCached(for: key))
        XCTAssertTrue(diskStorage.isCached(for: key))
        
        try! imageCache.removeImage(for: key, option: .disk)
        XCTAssertFalse(diskStorage.isCached(for: key))
        
        XCTAssertFalse(imageCache.isCached(for: key))
        try! imageCache.store(sampleImage, for: key, option: .all)
        try! imageCache.removeImage(for: key)
        XCTAssertFalse(memoryStorage.isCached(for: key))
        XCTAssertFalse(diskStorage.isCached(for: key))
    }
    
    func test_removeAll() {
        let keys = ["sample1", "sample2", "sample3"]
        keys.forEach {
            do {
                try imageCache.store(sampleImage, for: $0, option: .all)
            } catch {
                XCTFail("imageCache failed to store sampleImage")
            }
        }
        
        try! imageCache.removeAll(option: .memory)
        keys.forEach {
            XCTAssertFalse(memoryStorage.isCached(for: $0))
            XCTAssertTrue(diskStorage.isCached(for: $0))
        }
        
        try! imageCache.removeAll(option: .disk)
        keys.forEach {
            XCTAssertFalse(diskStorage.isCached(for: $0))
        }
        
        keys.forEach {
            do {
                try imageCache.store(sampleImage, for: $0, option: .all)
            } catch {
                XCTFail("imageCache failed to store sampleImage")
            }
        }
        try! imageCache.removeAll()
        keys.forEach {
            XCTAssertFalse(memoryStorage.isCached(for: $0))
            XCTAssertFalse(diskStorage.isCached(for: $0))
        }
    }
    
    func test_removeExpired() {
        let memoryExpectation = expectation(description: "removeExpired memory Expectation")
        let diskExpectation = expectation(description: "removeExpired disk Expectation")
        
        // memory expiration == 2, disk expiration == 3
        let key = "sample"
        try! imageCache.store(sampleImage, for: key)
        XCTAssertTrue(imageCache.isCached(for: key))
        
        delay(2) {
            try! self.imageCache.removeExpired()
            XCTAssertTrue(self.imageCache.isCached(for: key))
            XCTAssertFalse(self.memoryStorage.isCached(for: key))
            XCTAssertTrue(self.diskStorage.isCached(for: key))
            memoryExpectation.fulfill()
        }
        
        delay(4) {
            try! self.imageCache.removeExpired()
            XCTAssertFalse(self.imageCache.isCached(for: key))
            diskExpectation.fulfill()
        }
        
        wait(for: [memoryExpectation, diskExpectation], timeout: 6)
    }
    
    func test_removeExpiredWithCacheOption() {
        let memoryExpectation = expectation(description: "removeExpired memory Expectation")
        let diskExpectation = expectation(description: "removeExpired disk Expectation")
        
        let key = "sample"
        try! imageCache.store(sampleImage, for: key)
        XCTAssertTrue(imageCache.isCached(for: key))
        
        delay(2) {
            try! self.imageCache.removeExpired(option: .memory)
            XCTAssertTrue(self.imageCache.isCached(for: key))
            XCTAssertFalse(self.memoryStorage.isCached(for: key))
            XCTAssertTrue(self.diskStorage.isCached(for: key))
            memoryExpectation.fulfill()
        }
        
        delay(4) {
            try! self.imageCache.removeExpired(option: .disk)
            XCTAssertFalse(self.imageCache.isCached(for: key))
            diskExpectation.fulfill()
        }
        
        wait(for: [memoryExpectation, diskExpectation], timeout: 6)
    }
}
