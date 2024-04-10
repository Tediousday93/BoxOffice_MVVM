//
//  ImageProviderTest.swift
//  BoxOffice_MVVMTests
//
//  Created by Rowan on 2024/04/09.
//

import XCTest
@testable import BoxOffice_MVVM

class ImageProviderTest: XCTestCase {
    let dummyURL = URL(string: "https://boxoffice.testurl.com")!
    let sampleImage = Image(data: MockData.sampleImageData)!
    
    var imageProvider: ImageProvider!
    var mockCache: MockImageCache!
    var networkSession: NetworkSession!
    var dummyRequest: URLRequest!
    
    var expectation: XCTestExpectation!
    
    override func setUp() {
        let networkConfiguration = URLSessionConfiguration.ephemeral
        networkConfiguration.protocolClasses = [MockURLProtocol.self]
        
        networkSession = .init(session: URLSession(configuration: networkConfiguration))
        mockCache = .init()
        imageProvider = .init(cache: mockCache, loader: networkSession)
        dummyRequest = .init(url: dummyURL)
        expectation = expectation(description: "ImageProvider Expectation")
    }
    
    override func tearDown() {
        mockCache = nil
        networkSession = nil
        imageProvider = nil
        dummyRequest = nil
        expectation = nil
    }
    
    func test_fetchCachedImage() {
        let cacheKey = dummyURL.cacheKey
        try! mockCache.store(sampleImage, for: cacheKey)
        
        imageProvider.fetchImage(from: dummyURL) { result in
            switch result {
            case let .success(image):
                XCTAssertTrue(self.mockCache.isCacheHit)
                XCTAssertTrue(self.mockCache.isCached(for: cacheKey))
                XCTAssertEqual(image, self.sampleImage)
                
                self.expectation.fulfill()
            case let .failure(error):
                XCTFail("Unexpected Error: \(error)")
            }
        }
        
        wait(for: [expectation], timeout: 1)
    }
}
