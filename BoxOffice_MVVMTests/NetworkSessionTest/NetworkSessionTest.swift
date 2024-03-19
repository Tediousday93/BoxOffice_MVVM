//
//  NetworkSessionTest.swift
//  BoxOffice_MVVMTests
//
//  Created by Rowan on 2024/03/18.
//

import XCTest
@testable import BoxOffice_MVVM

class NetworkSessionTest: XCTestCase {
    let dummyURL = URL(string: "https://boxoffice.testurl.com")!
    
    var networkSession: NetworkSession!
    var expectation: XCTestExpectation!
    var dummyRequest: URLRequest!
    
    override func setUp() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        
        networkSession = NetworkSession(session: URLSession(configuration: configuration))
        expectation = .init(description: "NetworkSession Expectation")
        dummyRequest = URLRequest(url: dummyURL)
    }
    
    override func tearDown() {
        networkSession = nil
        expectation = nil
    }
    
    func test_dataTaskSuccess() {
        // given
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url else {
                throw NetworkError.invalidURL
            }
            let emptyData = Data()
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response, emptyData)
        }
        
        // when
        networkSession.dataTask(with: dummyRequest) { result in
            switch result {
            case let .success(data):
                XCTAssertNotNil(data)
            case let .failure(error):
                XCTFail("Not Expected Error: \(error)")
            }
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_dataTaskFailure_responseNotFound() {
        // given
        MockURLProtocol.requestHandler = { request in
            return (nil, nil)
        }
        
        // when
        networkSession.dataTask(with: dummyRequest) { result in
            // then
            switch result {
            case .success:
                XCTFail("This Request Must Throw Error")
            case let .failure(error):
                guard let error = error as? NetworkError else {
                    XCTFail("Did Not Throw Network Error")
                    return
                }
                XCTAssertEqual(error, NetworkError.responseNotFound)
            }
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_dataTaskFailure_invalidHttpStatusCode() {
        // given
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url else {
                throw NetworkError.invalidURL
            }
            
            let response = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)
            
            return (response, nil)
        }
        
        // when
        networkSession.dataTask(with: dummyRequest) { result in
            switch result {
            case .success:
                XCTFail("This Request Must Throw Error")
            case let .failure(error):
                guard let error = error as? NetworkError else {
                    XCTFail("Unexpected Error")
                    return
                }
                XCTAssertEqual(error, NetworkError.invalidHttpStatusCode(statusCode: 404))
            }
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
