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
    
    private var expectation: XCTestExpectation!
    
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
    
    func test_initRemoveExpiredCall() {
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url else {
                throw NetworkError.invalidURL
            }
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response, MockData.sampleImageData)
        }
        
        try! mockCache.store(sampleImage, for: dummyURL.cacheKey)
        mockCache.isCacheExpired = true
        XCTAssertFalse(mockCache.isCached(for: dummyURL.cacheKey))
        
        imageProvider = .init(cache: mockCache, loader: networkSession)
        
        XCTAssertFalse(mockCache.isCacheExpired)
        XCTAssertFalse(mockCache.isCached(for: dummyURL.cacheKey))
        
        imageProvider.fetchImage(from: dummyURL) { result in
            switch result {
            case let .success(image):
                XCTAssertFalse(self.mockCache.isCacheHit)
                XCTAssertTrue(self.mockCache.isCached(for: self.dummyURL.cacheKey))
                XCTAssertEqual(
                    image.jpegData(compressionQuality: 1.0),
                    self.sampleImage.jpegData(compressionQuality: 1.0)
                )
                
                self.expectation.fulfill()
            case let .failure(error):
                XCTFail("Unexpected Error: \(error)")
            }
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_fetchImageWithDownload() {
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url else {
                throw NetworkError.invalidURL
            }
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response, MockData.sampleImageData)
        }
        
        let cacheKey = dummyURL.cacheKey
        
        imageProvider.fetchImage(from: dummyURL) { result in
            switch result {
            case let .success(image):
                XCTAssertEqual(
                    image.jpegData(compressionQuality: 1.0),
                    self.sampleImage.jpegData(compressionQuality: 1.0)
                )
                XCTAssertTrue(self.mockCache.isCached(for: cacheKey))
                
                self.expectation.fulfill()
            case let .failure(error):
                XCTFail("Unexpected Error: \(error)")
            }
        }
        
        wait(for: [expectation], timeout: 2)
    }
    
    func test_fetchCachedImage() {
        let cacheKey = dummyURL.cacheKey
        try! mockCache.store(sampleImage, for: cacheKey)
        
        imageProvider.fetchImage(from: dummyURL) { result in
            switch result {
            case let .success(image):
                XCTAssertTrue(self.mockCache.isCacheHit)
                XCTAssertTrue(self.mockCache.isCached(for: cacheKey))
                XCTAssertEqual(
                    image.jpegData(compressionQuality: 1.0),
                    self.sampleImage.jpegData(compressionQuality: 1.0)
                )
                
                self.expectation.fulfill()
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
        
        imageProvider.fetchImage(from: dummyURL) { result in
            switch result {
            case .success:
                XCTFail("This request must throw error")
            case let .failure(error):
                if let error = error as? ImageProviderError {
                    XCTAssertEqual(error, .imageConvertingFail(imageURL: self.dummyURL))
                }
                
                self.expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 2)
    }
}
