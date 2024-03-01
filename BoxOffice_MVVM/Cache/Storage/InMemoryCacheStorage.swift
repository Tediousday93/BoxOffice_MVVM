//
//  InMemoryCacheStorage.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/02/28.
//

import Foundation
import UIKit.UIImage

final class InMemoryCacheStorage {
    private let storage: NSCache<NSString, UIImage> = .init()
    
    init(countLimit: Int) {
        storage.countLimit = countLimit
    }
    
    func store(for key: String, data: UIImage) {
        storage.setObject(data, forKey: key as NSString)
    }
    
    func retrive(for key: String) -> UIImage? {
        storage.object(forKey: key as NSString)
    }
}
