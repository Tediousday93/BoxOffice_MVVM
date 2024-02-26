//
//  NetworkJSONDecoder.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/02/23.
//

import Foundation

struct NetworkJSONDecoder: NetworkJSONDecodable {
    func decode<T: Decodable>(_ data: Data, to type: T.Type) throws -> T {
        try JSONDecoder().decode(T.self, from: data)
    }
}
