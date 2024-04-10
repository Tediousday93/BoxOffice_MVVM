//
//  BoxOfficeTest.swift
//  BoxOffice_MVVMTests
//
//  Created by Rowan on 2024/04/10.
//

import XCTest
@testable import BoxOffice_MVVM

class BoxOfficeTest: XCTestCase {
    var boxOffice: BoxOffice!
    var expectation: XCTestExpectation!
    
    override func setUp() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = NetworkSession(session: URLSession(configuration: configuration))
        
        boxOffice = .init(
            dailyBoxOfficeProvider: .init(networkSession: session),
            movieDetailsProvider: .init(networkSession: session)
        )
        
        expectation = expectation(description: "BoxOfficeTest Expectation")
    }
    
    override func tearDown() {
        boxOffice = nil
        expectation = nil
    }
}
