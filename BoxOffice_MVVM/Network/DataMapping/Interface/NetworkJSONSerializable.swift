//
//  NetworkJSONSerializable.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/02/23.
//

import Foundation

protocol NetworkJSONSerializable {
    func serialize(_ parameters: [String: Any]) throws -> Data
}
