//
//  NetworkError.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/02/20.
//

enum NetworkError: Error {
    case unknown
    case responseNotFound
    case invalidHttpStatusCode(statusCode: Int)
    case emptyData
    case invalidURL
}
