//
//  ImageCacheType.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/03/09.
//

import Foundation

protocol ImageCacheType {
    func store(_ image: Image, for key: String, option: CacheOption?) throws
    
    func retrieveImage(for key: String) throws -> Image?
    
    func removeImage(for key: String, option: CacheOption?) throws
    
    func removeAll(option: CacheOption?) throws
    
    func removeExpired(option: CacheOption?) throws
    
    func isCached(for key: String) throws -> Bool
}
