//
//  MockImageURLSearcher.swift
//  BoxOffice_MVVMTests
//
//  Created by Rowan on 5/10/24.
//

import Foundation
@testable import BoxOffice_MVVM

final class MockImageURLSearcher: ImageURLSearchable {
    var searchCallCount = 0
    var searchSingleCallCount = 0
    var willThrowNetworkError: Bool = false
    
    func search(for keyword: String, completion: @escaping (Result<[URL], any Error>) -> Void) {
        if willThrowNetworkError {
            completion(.failure(NetworkError.unknown))
            return
        }
        
        var urls: [URL] = []
        let dummyURL = URL(string: "https://boxoffice.testurl.com")!
        for _ in 0..<10 {
            urls.append(dummyURL)
        }
        completion(.success(urls))
    }
    
    func searchSingle(for keyword: String, completion: @escaping (Result<URL, any Error>) -> Void) {
        if willThrowNetworkError {
            completion(.failure(NetworkError.unknown))
            return
        }
        
        let dummyURL = URL(string: "https://boxoffice.testurl.com")!
        completion(.success(dummyURL))
    }
}
