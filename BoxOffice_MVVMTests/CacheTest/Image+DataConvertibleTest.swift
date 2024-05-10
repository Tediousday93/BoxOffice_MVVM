//
//  Image+DataConvertibleTest.swift
//  BoxOffice_MVVMTests
//
//  Created by Rowan on 2024/03/21.
//

import XCTest
@testable import BoxOffice_MVVM

final class ImageDataConvertibleTest: XCTestCase {
    private var image: Image!
    
    override func setUp() {
        image = Image(data: MockData.sampleImageData)
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
        do {
            let image = try Image.fromData(MockData.sampleImageData)
            XCTAssertTrue(type(of: image) == Image.self)
        } catch {
            XCTFail("Not Expected Error: \(error)")
        }
    }
    
    func test_empty() {
        let emptyImage = Image.empty
        XCTAssertTrue(type(of: emptyImage) == Image.self)
        XCTAssertNil(emptyImage.jpegData(compressionQuality: 1.0))
    }
}
