//
//  DaumImageSearchAPITest.swift
//  BoxOffice_MVVMTests
//
//  Created by Rowan on 2024/03/19.
//

import XCTest
@testable import BoxOffice_MVVM

class DaumImageSearchAPITest: XCTestCase {
    var apiProvider: NetworkProvider<DaumImageSearchAPI>!
    var expectation: XCTestExpectation!
    
    override func setUp() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        
        apiProvider = .init(networkSession: NetworkSession(session: urlSession))
        expectation = .init(description: "DaumImageSearchAPITest Expectation")
    }
    
    override func tearDown() {
        apiProvider = nil
        expectation = nil
    }
    
    func test_requestSuccess() {
        // given
        let mockData = MockData.daumSearchResult
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url else {
                throw NetworkError.invalidURL
            }
            
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response, mockData)
        }
        let documentsCount = 10
        let queryKeyword = "광해, 왕이 된 남자 영화 포스터"
        
        // when
        let api = DaumImageSearchAPI(
            queryParameters: .query(keyword: queryKeyword), .size(documentsCount)
        )
        apiProvider.request(api) { result in
            // then
            switch result {
            case let .success(daumImageSearchResult):
                XCTAssertEqual(daumImageSearchResult.documents.count, documentsCount)
                
                guard let firstDocument = daumImageSearchResult.documents.first else {
                    XCTFail("Documents must contain some contents")
                    return
                }
                XCTAssertEqual(firstDocument.imageURL, "https://t1.daumcdn.net/news/201901/03/nocut/20190103153601230nltn.jpg")
                
            case let .failure(error):
                XCTFail("Not Expected Error: \(error)")
            }
            
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
