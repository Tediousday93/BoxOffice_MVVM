//
//  MovieDetailsViewModel.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/04/18.
//

import Foundation

final class MovieDetailsViewModel {
    let movieTitle: Observable<String> = .init()
    let movieInfo: Observable<MovieInfo> = .init()
    let posterURL: Observable<URL> = .init()
    let thrownError: Observable<Error> = .init()
    
    private let movieCode: String
    
    private let boxOffice: BoxOfficeType
    
    private let imageURLSearcher: ImageURLSearchable
    
    init(
        movieCode: String,
        movieTitle: String,
        boxOffice: BoxOfficeType,
        imageURLSearcher: ImageURLSearchable
    ) {
        self.movieCode = movieCode
        self.movieTitle.value = movieTitle
        self.boxOffice = boxOffice
        self.imageURLSearcher = imageURLSearcher
        
        setUpBindings()
        fetchMovieInfo()
    }
    
    private func setUpBindings() {
        movieTitle.subscribe { [weak self] title in
            self?.searchImageURL(query: title + Constant.querySuffix)
        }
    }
    
    func fetchMovieInfo() {
        boxOffice.getMovieDetails(movieCode: movieCode) { result in
            switch result {
            case let .success(movieDetails):
                self.movieInfo.value = movieDetails.movieInfoResult.movieInfo
            case let .failure(error):
                self.thrownError.value = error
            }
        }
    }
    
    func searchImageURL(query: String) {
        imageURLSearcher.searchSingle(for: query) { result in
            switch result {
            case let .success(url):
                self.posterURL.value = url
            case let .failure(error):
                self.thrownError.value = error
            }
        }
    }
}

extension MovieDetailsViewModel {
    private enum Constant {
        static let querySuffix = " 영화 포스터"
    }
}
