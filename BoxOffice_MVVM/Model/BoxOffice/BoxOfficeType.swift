//
//  BoxOfficeType.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/02/26.
//

protocol BoxOfficeType {
    func getDaily(
        targetDate: String,
        completion: @escaping (Result<DailyBoxOffice, Error>) -> Void
    )
    
    func getMovieDetails(
        movieCode: String,
        completion: @escaping (Result<MovieDetails, Error>) -> Void
    )
}
