//
//  NetworkSessionType.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/02/21.
//

import Foundation

protocol NetworkSessionType {
    func dataTask(
        with request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    )
    
    func dataTask(
        with url: URL,
        completion: @escaping (Result<Data, Error>) -> Void
    )
}
