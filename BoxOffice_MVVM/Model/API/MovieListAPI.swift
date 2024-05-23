//
//  MovieListAPI.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 5/22/24.
//

import Foundation

struct MovieListAPI: APIConfigurationType {
    typealias Response = MovieSearchResult
    
    var baseURL: String {
        "http://www.kobis.or.kr/kobisopenapi/webservice/rest/"
    }
    
    var path: String {
        "movie/searchMovieList.json"
    }
    
    var method: HTTPMethod { .get }
    
    var headers: [String : String] { [:] }
    
    var queryParameters: [String : Any] = {
        guard let apiKey = Bundle.main.infoDictionary?["KOBIS_API_KEY"]
        else { fatalError("Could not find KOBIS_API_KEY from main bundle's infoDictionary") }
        
        var parameters: [String: Any] = ["key": apiKey]
        
        return parameters
    }()
    
    var bodyParameters: [String : Any]? = nil
    
    init(queryParameters: QueryParamter...) {
        for parameter in queryParameters {
            self.queryParameters[parameter.key] = parameter.value
        }
    }
}

extension MovieListAPI {
    enum QueryParamter {
        case page(Int)
        case itemPerPage(Int)
        case movie(name: String)
        case director(name: String)
        
        var key: String {
            switch self {
            case .page:
                return "curPage"
            case .itemPerPage:
                return "itemPerPage"
            case .movie:
                return "movieNm"
            case .director:
                return "directorNm"
            }
        }
        
        var value: Any {
            switch self {
            case let .page(page):
                return page
            case let .itemPerPage(count):
                return count
            case let .movie(name):
                return name
            case let .director(name):
                return name
            }
        }
    }
}
