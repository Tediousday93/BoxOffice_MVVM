//
//  BoxOffice.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/02/26.
//

import Foundation

final class BoxOffice: BoxOfficeType {
    private let dailyBoxOfficeProvider: NetworkProvider<DailyBoxOfficeAPI>
    
    private let movieDetailsProvider: NetworkProvider<MovieDetailsAPI>
    
    init(
        dailyBoxOfficeProvider: NetworkProvider<DailyBoxOfficeAPI>,
        movieDetailsProvider: NetworkProvider<MovieDetailsAPI>
    ) {
        self.dailyBoxOfficeProvider = dailyBoxOfficeProvider
        self.movieDetailsProvider = movieDetailsProvider
    }
    
    func getDaily(
        targetDate: String,
        completion: @escaping (Result<DailyBoxOffice, Error>) -> Void
    ) {
        dailyBoxOfficeProvider.request(
            .init(targetDate: targetDate)
        ) { result in
            switch result {
            case let .success(dailyBoxOffice):
                completion(.success(dailyBoxOffice))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func getDetail(
        movieCode: String,
        completion: @escaping (Result<MovieDetails, Error>) -> Void
    ) {
        movieDetailsProvider.request(
            .init(movieCode: movieCode)
        ) { result in
            switch result {
            case let .success(movieDetails):
                completion(.success(movieDetails))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
