//
//  MockImageURLSearcher.swift
//  BoxOffice_MVVMTests
//
//  Created by Rowan on 5/10/24.
//

import Foundation
@testable import BoxOffice_MVVM

final class MockImageURLSearcher: ImageURLSearchable {
    let dummyURL = URL(string: "https://boxoffice.testurl.com")!
    
    var searchCallCount = 0
    var searchSingleCallCount = 0
    var willThrowNetworkError: Bool = false
    
    func search(for keyword: String, completion: @escaping (Result<[URL], any Error>) -> Void) {
        searchCallCount += 1
        
        if willThrowNetworkError {
            completion(.failure(NetworkError.unknown))
            return
        }
        
        var urls: [URL] = []
        for _ in 0..<10 {
            urls.append(dummyURL)
        }
        completion(.success(urls))
    }
    
    func searchSingle(for keyword: String, completion: @escaping (Result<URL, any Error>) -> Void) {
        searchSingleCallCount += 1
        
        if willThrowNetworkError {
            completion(.failure(NetworkError.unknown))
            return
        }
        
        completion(.success(dummyURL))
    }
}
