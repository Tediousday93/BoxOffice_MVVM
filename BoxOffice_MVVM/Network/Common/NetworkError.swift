//
//  NetworkError.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/02/20.
//

enum NetworkError: Error, Equatable {
    case unknown
    case responseNotFound
    case invalidHttpStatusCode(statusCode: Int)
    case nilData
    case invalidURL
}
