//
//  ImageProviderTest.swift
//  BoxOffice_MVVMTests
//
//  Created by Rowan on 2024/04/09.
//

import XCTest
@testable import BoxOffice_MVVM

final class ImageProviderTest: XCTestCase {
    private let dummyURL = URL(string: "https://boxoffice.testurl.com")!
    private let sampleImage = Image(data: MockData.sampleImageData)!
    
    private var imageProvider: ImageProvider!
    private var mockCache: MockImageCache!
    private var networkSession: NetworkSession!
    private var dummyRequest: URLRequest!
    
    override func setUp() {
        let networkConfiguration = URLSessionConfiguration.ephemeral
        networkConfiguration.protocolClasses = [MockURLProtocol.self]
        
        networkSession = .init(session: URLSession(configuration: networkConfiguration))
        mockCache = .init()
        imageProvider = .init(cache: mockCache, loader: networkSession)
        dummyRequest = .init(url: dummyURL)
    }
    
    override func tearDown() {
        mockCache = nil
        networkSession = nil
        imageProvider = nil
        dummyRequest = nil
    }
    
    func test_initRemoveExpiredCall() {
        try! mockCache.store(sampleImage, for: dummyURL.cacheKey)
        mockCache.isCacheExpired = true
        XCTAssertFalse(mockCache.isCached(for: dummyURL.cacheKey))
        
        imageProvider = .init(cache: mockCache, loader: networkSession)
        
        XCTAssertFalse(mockCache.isCached(for: dummyURL.cacheKey))
        XCTAssertEqual(mockCache.removeExpiredCallCount, 2)
        XCTAssertTrue(mockCache.storage.isEmpty)
    }
    
    func test_fetchImageWithDownload() {
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url else {
                throw NetworkError.invalidURL
            }
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response, MockData.sampleImageData)
        }
        var expectation = expectation(description: "ImageProvider Expectation")
        let cacheKey = dummyURL.cacheKey
        
        imageProvider.fetchImage(from: dummyURL) { result in
            switch result {
            case let .success(image):
                XCTAssertEqual(self.mockCache.cacheHitCount, 0)
                XCTAssertEqual(
                    image.jpegData(compressionQuality: 1.0),
                    self.sampleImage.jpegData(compressionQuality: 1.0)
                )
                XCTAssertTrue(self.mockCache.isCached(for: cacheKey))
                
                expectation.fulfill()
            case let .failure(error):
                XCTFail("Unexpected Error: \(error)")
            }
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_fetchImageFromCache() {
        var expectation = expectation(description: "ImageProvider Expectation")
        let cacheKey = dummyURL.cacheKey
        try! mockCache.store(sampleImage, for: cacheKey)
        
        imageProvider.fetchImage(from: dummyURL) { result in
            switch result {
            case let .success(image):
                XCTAssertEqual(self.mockCache.cacheHitCount, 1)
                XCTAssertTrue(self.mockCache.isCached(for: cacheKey))
                XCTAssertEqual(
                    image.jpegData(compressionQuality: 1.0),
                    self.sampleImage.jpegData(compressionQuality: 1.0)
                )
                
                expectation.fulfill()
            case let .failure(error):
                XCTFail("Unexpected Error: \(error)")
            }
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_fetchImageConvertingFailure() {
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url else {
                throw NetworkError.invalidURL
            }
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response, Data())
        }
        var expectation = expectation(description: "ImageProvider Expectation")
        
        imageProvider.fetchImage(from: dummyURL) { result in
            switch result {
            case .success:
                XCTFail("This request must throw error")
            case let .failure(error):
                if let error = error as? ImageProviderError {
                    XCTAssertEqual(error, .imageConvertingFail(imageURL: self.dummyURL))
                }
                
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1)
    }
}
