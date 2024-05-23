//
//  DailyBoxOfficeAPITest.swift
//  BoxOffice_MVVMTests
//
//  Created by Rowan on 2024/03/15.
//

import XCTest
@testable import BoxOffice_MVVM

final class DailyBoxOfficeAPITest: XCTestCase {
    private var apiProvider: NetworkProvider<DailyBoxOfficeAPI>!
    private var expectation: XCTestExpectation!
    
    override func setUp() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        
        apiProvider = .init(networkSession: NetworkSession(session: urlSession))
        expectation = .init(description: "DailyBoxOfficeAPITest Expectation")
    }
    
    override func tearDown() {
        apiProvider = nil
        expectation = nil
    }
    
    func test_requestSuccess() {
        // given
        let mockData = MockData.dailyBoxOffice
        
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url else {
                throw NetworkError.invalidURL
            }
            
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response, mockData)
        }
        
        // when
        let api = DailyBoxOfficeAPI(queryParameters: .targetDate("20120101"))
        apiProvider.request(api) { result in
            // then
            switch result {
            case let .success(dailyBoxOffice):
                XCTAssertEqual(dailyBoxOffice.boxOfficeResult.boxOfficeType, "일별 박스오피스")
                XCTAssertEqual(dailyBoxOffice.boxOfficeResult.showRange, "20120101~20120101")
                
                let dailyBoxOfficeList = dailyBoxOffice.boxOfficeResult.dailyBoxOfficeList
                XCTAssertEqual(dailyBoxOfficeList.count, 10)
                
                guard let firstMovie = dailyBoxOfficeList.first else {
                    XCTFail("BoxOfficeList is Empty")
                    return
                }
                XCTAssertEqual(firstMovie.movieName, "미션임파서블:고스트프로토콜")
                XCTAssertEqual(firstMovie.movieCode, "20112207")
                XCTAssertEqual(firstMovie.rankOldAndNew, .old)
                XCTAssertEqual(firstMovie.rank, "1")
                XCTAssertEqual(firstMovie.rankDifference, "0")
            case let .failure(error):
                XCTFail("Not Expected Error: \(error)")
            }
            
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
