//
//  APIConfigurationType.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/02/15.
//

import Foundation

protocol APIConfigurationType {
    var baseURL: String { get }
    var path: String { get }
    var queries: [String: String] { get set }
    var headers: [String: String] { get set }
    var sampleData: Data? { get }
}
