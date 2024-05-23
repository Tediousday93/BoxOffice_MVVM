//
//  MovieSearchResult.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 5/22/24.
//

import Foundation

struct MovieSearchResult: Decodable {
    let movieListResult: MovieListResult
    
    var totalCount: Int {
        return movieListResult.totalCount
    }
    
    var movieList: [MovieListResult.SearchedMovie] {
        return movieListResult.movieList
    }
}

struct MovieListResult: Decodable {
    struct SearchedMovie: Decodable {
        let movieCode: String
        let movieName: String
        let openDate: String
        let genres: String
        let directors: [Director]

        enum CodingKeys: String, CodingKey {
            case movieCode = "movieCd"
            case movieName = "movieNm"
            case openDate = "openDt"
            case genres = "genreAlt"
            case directors
        }
        
        struct Director: Decodable {
            let name: String
            
            enum CodingKeys:String, CodingKey {
                case name = "peopleNm"
            }
        }
    }
    
    let totalCount: Int
    let movieList: [SearchedMovie]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "totCnt"
        case movieList
    }
}
