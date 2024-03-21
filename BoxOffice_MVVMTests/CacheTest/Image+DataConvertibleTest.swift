//
//  Image+DataConvertibleTest.swift
//  BoxOffice_MVVMTests
//
//  Created by Rowan on 2024/03/21.
//

import XCTest
@testable import BoxOffice_MVVM

class ImageDataConvertibleTest: XCTestCase {
    var image: Image!
    
    override func setUp() {
        image = Image(named: "samplePoster")
    }
    
    override func tearDown() {
        image = nil
    }
    
    func test_toData() {
        guard let jpegData = image.jpegData(compressionQuality: 1.0) else {
            XCTFail("Converting image to jpeg failed")
            return
        }
        
        do {
            let data = try image.toData()
            XCTAssertTrue(data == jpegData)
        } catch {
            XCTFail("Not Expected Error: \(error)")
        }
    }
    
    func test_fromData() {
        guard let jpegData = image.jpegData(compressionQuality: 1.0) else {
            XCTFail("Converting image to jpeg failed")
            return
        }
        
        XCTAssertNoThrow(try Image.fromData(jpegData))
    }
    
    func test_empty() {
        let emptyImage = Image.empty
        
        XCTAssertNil(emptyImage.jpegData(compressionQuality: 1.0))
    }
}
