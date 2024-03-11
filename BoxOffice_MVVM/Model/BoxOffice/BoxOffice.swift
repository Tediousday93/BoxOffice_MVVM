//
//  BoxOffice.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/02/26.
//

import Foundation

final class BoxOffice: BoxOfficeType {
    private let provider: NetworkProvider<KobisAPI>
    
    init(provider: NetworkProvider<KobisAPI>) {
        self.provider = provider
    }
    
    func getDaily(
        targetDate: String,
        completion: @escaping (Result<DailyBoxOffice, Error>) -> Void
    ) {
        provider.request(
            .dailyBoxOffice(responseType: DailyBoxOffice.self, targetDate: targetDate)
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
        provider.request(
            .movieDetail(responseType: MovieDetails.self, movieCode: movieCode)
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
