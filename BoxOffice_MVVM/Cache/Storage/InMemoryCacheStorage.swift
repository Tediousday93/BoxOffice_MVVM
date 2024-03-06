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
    
    private let lock: NSLock = .init()
    
    init(countLimit: Int) {
        storage.countLimit = countLimit
    }
    
    func store(_ value: UIImage, for key: String) {
        lock.lock()
        defer { lock.unlock() }
        storage.setObject(value, forKey: key as NSString)
    }
    
    func value(for key: String) -> UIImage? {
        storage.object(forKey: key as NSString)
    }
}
