//
//  DataConvertible.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/03/20.
//

import Foundation

protocol DataConvertible {
    func toData() throws -> Data
    
    static func fromData(_ data: Data) throws -> Self
    
    static var empty: Self { get }
}

enum DataConvertError: Error {
    case cannotConvertToData
    case cannotConvertFromData
}
