//
//  NetworkJSONDecodable.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/02/23.
//

import Foundation

protocol NetworkJSONDecodable {
    func decode<T: Decodable>(_ data: Data, to type: T.Type) throws -> T
}
