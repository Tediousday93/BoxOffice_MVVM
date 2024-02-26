//
//  KobisAPI.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/02/26.
//

import Foundation

enum KobisAPI<Response: Decodable>: APIConfigurationType {
    case dailyBoxOffice(responseType: Response.Type, targetDate: String)
    case movieDetail(responseType: Response.Type, movieCode: String)
    
    var baseURL: String {
        return "http://www.kobis.or.kr/kobisopenapi/webservice/rest/"
    }
    
    var path: String {
        switch self {
        case .dailyBoxOffice:
            return "boxoffice/searchDailyBoxOfficeList.json"
        case .movieDetail:
            return "movie/searchMovieInfo.json"
        }
    }
    
    var method: HTTPMethod { .get }
    
    var headers: [String : String] { [:] }
    
    var queryParameters: [String : Any] {
        switch self {
        case let .dailyBoxOffice(_, targetDate):
            guard let key = Bundle.main.infoDictionary?["KOBIS_API_KEY"]
            else { fatalError("Could not find KOBIS_API_KEY from main bundle's infoDictionary") }
            
            return [
                "key": key,
                "targetDt": targetDate
            ]
        case let .movieDetail(_, movieCode):
            guard let key = Bundle.main.infoDictionary?["KOBIS_API_KEY"]
            else { fatalError("Could not find KOBIS_API_KEY from main bundle's infoDictionary") }
            
            return [
                "key": key,
                "movieCd": movieCode
            ]
        }
    }
    
    var bodyParameters: [String : Any] { [:] }
}
