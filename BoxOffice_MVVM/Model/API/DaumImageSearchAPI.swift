//
//  DaumImageSearchAPI.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/02/27.
//

import Foundation

struct DaumImageSearchAPI: APIConfigurationType {
    typealias Response = DaumImageSearchResult
    
    var baseURL: String { "https://dapi.kakao.com/v2" }
    
    var path: String { "/search/image" }
    
    var method: HTTPMethod { .get }
    
    var headers: [String : String] {
        guard let key = Bundle.main.infoDictionary?["DAUM_SEARCH_API_KEY"] as? String
        else { fatalError("Could not find DAUM_SEARCH_API_KEY from main bundle's infoDictionary") }
        
        return [
            "Authorization": "KakaoAK " + key
        ]
    }
    
    var queryParameters: [String : Any]
    
    var bodyParameters: [String : Any]? = nil
    
    init(queryParameters: QueryParameter...) {
        var queries: [String: Any] = [:]
        queryParameters.forEach { parameter in
            queries[parameter.key] = parameter.value
        }
        
        self.queryParameters = queries
    }
}

extension DaumImageSearchAPI {
    enum QueryParameter {
        case query(keyword: String)
        case sort(method: Sorting)
        case page(number: Int)
        case size(Int)
        
        var key: String {
            switch self {
            case .query: return "query"
            case .sort: return "sort"
            case .page: return "page"
            case .size: return "size"
            }
        }
        
        var value: Any {
            switch self {
            case let .query(keyword): return keyword
            case let .sort(method): return method
            case let .page(number): return number
            case let .size(count): return count
            }
        }
    }
        
    enum Sorting: String {
        case accuracy
        case recency
    }
}
