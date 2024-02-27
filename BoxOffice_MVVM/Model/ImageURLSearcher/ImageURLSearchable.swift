//
//  ImageURLSearchable.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/02/27.
//

import Foundation

protocol ImageURLSearchable {
    func searchSingle(
        for keyword: String,
        completion: @escaping (Result<URL, Error>) -> Void
    )
    
    func search(
        for keyword: String,
        completion: @escaping (Result<[URL], Error>) -> Void
    )
}
