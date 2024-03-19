//
//  DailyBoxOfficeAPI.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/03/15.
//

import Foundation

struct DailyBoxOfficeAPI: APIConfigurationType {
    typealias Response = DailyBoxOffice
    
    let targetDate: String
    
    var baseURL: String {
        "http://www.kobis.or.kr/kobisopenapi/webservice/rest/"
    }
    
    var path: String {
        "boxoffice/searchDailyBoxOfficeList.json"
    }
    
    var method: HTTPMethod { .get }
    
    var headers: [String : String] { [:] }
    
    var queryParameters: [String : Any] {
        guard let key = Bundle.main.infoDictionary?["KOBIS_API_KEY"]
        else { fatalError("Could not find KOBIS_API_KEY from main bundle's infoDictionary") }
        
        return [
            "key": key,
            "targetDt": targetDate
        ]
    }
    
    var bodyParameters: [String : Any] { [:] }
}
