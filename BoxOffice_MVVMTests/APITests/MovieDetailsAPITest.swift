//
//  MovieDetailsAPITest.swift
//  BoxOffice_MVVMTests
//
//  Created by Rowan on 2024/03/19.
//

import XCTest
@testable import BoxOffice_MVVM

class MovieDetailsAPITest: XCTestCase {
    var apiProvider: NetworkProvider<MovieDetailsAPI>!
    var expectation: XCTestExpectation!
    
    override func setUp() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        
        apiProvider = .init(networkSession: NetworkSession(session: urlSession))
        expectation = .init(description: "MovieDetailsAPI Expectation")
    }
    
    override func tearDown() {
        apiProvider = nil
        expectation = nil
    }
    
    func test_requestSuccess() {
        // given
        let successData = MockData.movieDetails
        
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url else {
                throw NetworkError.invalidURL
            }
            
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response, successData)
        }
        
        // when
        apiProvider.request(.init(movieCode: "20124079")) { result in
            switch result {
            case let .success(movieDetails):
                let movieInfo = movieDetails.movieInfoResult.movieInfo
                
                XCTAssertEqual(movieInfo.movieCode, "20124079")
                XCTAssertEqual(movieInfo.movieName, "광해, 왕이 된 남자")
                XCTAssertEqual(movieInfo.productionYear, "2012")
                XCTAssertEqual(movieInfo.openDate, "20120913")
                XCTAssertEqual(movieInfo.runningTime, "131")
                
                guard let directorName = movieInfo.directors.first?.personName else {
                    XCTFail("directorName must be contained")
                    return
                }
                XCTAssertEqual(directorName, "추창민")
                
                guard let watchGradeName = movieInfo.audits.first?.watchGradeName else {
                    XCTFail("watchGradeName must be contained")
                    return
                }
                XCTAssertEqual(watchGradeName, "15세이상관람가")
                
                guard let nationName = movieInfo.nations.first?.nationName else {
                    XCTFail("nationName must be contained")
                    return
                }
                XCTAssertEqual(nationName, "한국")
                
                let genreNames = movieInfo.genres
                    .map { $0.genreName }
                    .joined(separator: ", ")
                XCTAssertEqual(genreNames, "사극, 드라마")
                
                guard let firstActorName = movieInfo.actors.first?.personName else {
                    XCTFail("firstActor must be contained")
                    return
                }
                XCTAssertEqual(firstActorName, "이병헌")
            case let .failure(error):
                XCTFail("Not Expected Error: \(error)")
            }
            
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
