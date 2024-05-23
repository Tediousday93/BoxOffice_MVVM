//
//  MovieDetailsAPI.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/03/15.
//

import Foundation

struct MovieDetailsAPI: APIConfigurationType {
    typealias Response = MovieDetails
    
    var baseURL: String {
        "http://www.kobis.or.kr/kobisopenapi/webservice/rest/"
    }
    
    var path: String {
        "movie/searchMovieInfo.json"
    }
    
    var method: HTTPMethod { .get }
    
    var headers: [String : String] { [:] }
    
    var queryParameters: [String : Any] = {
        guard let apiKey = Bundle.main.infoDictionary?["KOBIS_API_KEY"]
        else { fatalError("Could not find KOBIS_API_KEY from main bundle's infoDictionary") }
        
        return ["key": apiKey]
    }()
    
    var bodyParameters: [String : Any]? = nil
    
    init(queryParameters: QueryParameter...) {
        for parameter in queryParameters {
            self.queryParameters[parameter.key] = parameter.value
        }
    }
}

extension MovieDetailsAPI {
    enum QueryParameter {
        case movieCode(String)
        
        var key: String {
            switch self {
            case .movieCode:
                return "movieCd"
            }
        }
        
        var value: Any {
            switch self {
            case let .movieCode(code):
                return code
            }
        }
    }
}
