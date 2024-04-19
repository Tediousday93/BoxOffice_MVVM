//
//  BoxOfficeType.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/02/26.
//

protocol DailyBoxOfficeProvidable {
    func getDaily(
        targetDate: String,
        completion: @escaping (Result<DailyBoxOffice, Error>) -> Void
    )
}

protocol MovieDetailsProvidable {
    func getMovieDetails(
        movieCode: String,
        completion: @escaping (Result<MovieDetails, Error>) -> Void
    )
}

protocol BoxOfficeType: DailyBoxOfficeProvidable, MovieDetailsProvidable { }
