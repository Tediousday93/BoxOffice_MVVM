//
//  MovieListAPITest.swift
//  BoxOffice_MVVMTests
//
//  Created by Rowan on 5/23/24.
//

import XCTest
@testable import BoxOffice_MVVM

final class MovieListAPITest: XCTestCase {
    var apiProvider: NetworkProvider<MovieListAPI>!
    var expectation: XCTestExpectation!
    
    override func setUp() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        
        apiProvider = .init(networkSession: NetworkSession(session: urlSession))
        expectation = .init(description: "MovieListAPITest Expectation")
    }
    
    override func tearDown() {
        apiProvider = nil
        expectation = nil
    }
    
    func test_requestSuccess() {
        // given
        let mockData = MockData.movieSearchResult
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url else {
                throw NetworkError.invalidURL
            }
            
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response, mockData)
        }
        let queryKeyword = "범죄와의전쟁"
        
        // when
        let api = MovieListAPI(queryParameters: .movie(name: queryKeyword))
        apiProvider.request(api) { result in
            // then
            switch result {
            case let .success(movieSearchResult):
                XCTAssertEqual(movieSearchResult.totalCount, 5)
                
                let list = movieSearchResult.movieList
                XCTAssertEqual(list.count, 5)
                
                let 범죄와의전쟁 = list[1]
                XCTAssertEqual(범죄와의전쟁.movieCode, "20113557")
                XCTAssertEqual(범죄와의전쟁.movieName, "범죄와의 전쟁: 나쁜놈들 전성시대")
                XCTAssertEqual(범죄와의전쟁.genres, "범죄,드라마")
                XCTAssertEqual(범죄와의전쟁.openDate, "20120202")
                XCTAssertEqual(범죄와의전쟁.directors.first?.name, "윤종빈")
            case let .failure(error):
                XCTFail("Not Expected Error: \(error)")
            }
            
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
