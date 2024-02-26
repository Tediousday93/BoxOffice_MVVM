//
//  NetworkJSONSerializer.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/02/23.
//

import Foundation

struct NetworkJSONSerializer: NetworkJSONSerializable {
    func serialize(_ parameters: [String: Any]) throws -> Data {
        try JSONSerialization.data(withJSONObject: parameters)
    }
}
