//
//  MockMovieDetailsProvider.swift
//  BoxOffice_MVVMTests
//
//  Created by Rowan on 5/10/24.
//

import Foundation
@testable import BoxOffice_MVVM

final class MockMovieDetailsProvider: MovieDetailsProvidable {
    var getMovieDetailsCallCount = 0
    var willThrowNetworkError: Bool = false
    
    func getMovieDetails(movieCode: String, completion: @escaping (Result<MovieDetails, any Error>) -> Void) {
        getMovieDetailsCallCount += 1
        
        if willThrowNetworkError {
            completion(.failure(NetworkError.unknown))
            return
        }
        
        let movieDetails = try! JSONDecoder().decode(MovieDetails.self, from: MockData.movieDetails)
        completion(.success(movieDetails))
    }
}
