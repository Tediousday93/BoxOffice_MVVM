//
//  MovieDetailsViewModel.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/04/18.
//

import Foundation

final class MovieDetailsViewModel {
    let movieDetailsItem: Observable<MovieDetailsItem> = .init()
    let posterURL: Observable<URL> = .init()
    let thrownError: Observable<Error> = .init()
    
    let movieTitle: String
    
    private let movieCode: String
    
    private let boxOffice: MovieDetailsProvidable
    
    private let imageURLSearcher: ImageURLSearchable
    
    private let dateFormatter: DateFormatter
    
    init(
        movieCode: String,
        movieTitle: String,
        boxOffice: MovieDetailsProvidable,
        imageURLSearcher: ImageURLSearchable,
        dateFormatter: DateFormatter
    ) {
        self.movieCode = movieCode
        self.movieTitle = movieTitle
        self.boxOffice = boxOffice
        self.imageURLSearcher = imageURLSearcher
        self.dateFormatter = dateFormatter
        
        searchImageURL(query: movieTitle + Constant.querySuffix)
        fetchMovieInfo()
    }
    
    private func searchImageURL(query: String) {
        imageURLSearcher.searchSingle(for: query) { result in
            switch result {
            case let .success(url):
                self.posterURL.value = url
            case let .failure(error):
                self.thrownError.value = error
            }
        }
    }
    
    private func fetchMovieInfo() {
        boxOffice.getMovieDetails(movieCode: movieCode) { result in
            switch result {
            case let .success(movieDetails):
                self.movieDetailsItem.value = self.parseMovieInfo(movieDetails.movieInfoResult.movieInfo)
            case let .failure(error):
                self.thrownError.value = error
            }
        }
    }
    
    private func parseMovieInfo(_ info: MovieInfo) -> MovieDetailsItem {
        let directors = info.directors
            .map { $0.personName }
            .joined(separator: ", ")
        
        let productionYear = info.productionYear
        
        var openDate = info.openDate
        let yearEndIndex = openDate.index(openDate.startIndex, offsetBy: 4)
        openDate.insert("-", at: yearEndIndex)
        let monthEndIndex = openDate.index(openDate.startIndex, offsetBy: 7)
        openDate.insert("-", at: monthEndIndex)
        
        let runningTime = info.runningTime + "분"
        
        let watchGrade = info.audits.first?.watchGradeName
        
        let nations = info.nations
            .map { $0.nationName }
            .joined(separator: ", ")
        
        let genres = info.genres
            .map { $0.genreName }
            .joined(separator: ", ")
        
        let actors = info.actors
            .map { $0.personName }
            .joined(separator: ", ")
        
        return MovieDetailsItem(directors: directors,
                                productionYear: productionYear,
                                openDate: openDate,
                                runningTime: runningTime,
                                watchGrade: watchGrade,
                                nations: nations,
                                genres: genres,
                                actors: actors)
    }
}

extension MovieDetailsViewModel {
    private enum Constant {
        static let querySuffix = " 포스터"
    }
}
