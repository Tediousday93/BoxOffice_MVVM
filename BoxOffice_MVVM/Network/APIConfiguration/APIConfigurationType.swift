//
//  APIConfigurationType.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/02/15.
//

import Foundation

protocol APIConfigurationType {
    associatedtype Response: Decodable
    
    var baseURL: URL { get }
    
    var path: String { get }
    
    var method: HTTPMethod { get }
    
    var headers: [String: String] { get }
    
    var queryParameters: [String: Any] { get }
}
