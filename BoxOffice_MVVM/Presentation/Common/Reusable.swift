//
//  Reusable.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/04/16.
//

import Foundation

protocol Reusable {
    static var reuseID: String {get}
}

extension Reusable {
    static var reuseID: String {
        return String(describing: type(of: self))
    }
}
