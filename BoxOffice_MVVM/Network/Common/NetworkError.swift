//
//  NetworkError.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/02/20.
//

import Foundation

enum NetworkError: Error {
    case unknownError
    case responseNotFound
    case invalidHttpStatusCode(statusCode: Int)
    case emptyData
    case invalidURL
}
