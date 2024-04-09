//
//  Image+DataConvertible.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/04/09.
//

import Foundation
import UIKit.UIImage

typealias Image = UIImage
extension Image: DataConvertible {
    func toData() throws -> Data {
        guard let data = jpegData(compressionQuality: 1.0)
        else { throw DataConvertError.cannotConvertToData }
        return data
    }
    
    static func fromData(_ data: Data) throws -> Self {
        guard let image = Image(data: data) as? Self
        else { throw DataConvertError.cannotConvertFromData }
        return image
    }
    
    static var empty: Self { Self() }
}
