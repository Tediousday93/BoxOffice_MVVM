//
//  ImageCacheTest.swift
//  BoxOffice_MVVMTests
//
//  Created by Rowan on 2024/04/08.
//

import XCTest
@testable import BoxOffice_MVVM

class ImageCacheTest: XCTestCase {
    var imageCache: ImageCache!
    
    var memoryStorage: InMemoryCacheStorage<Image>!
    var diskStorage: OnDiskCacheStorage<Image>!
    
    override func setUpWithError() throws {
        memoryStorage = .init(countLimit: 3,
                              cacheExpiration: .seconds(5),
                              cleanInterval: 2)
        diskStorage = try .init(countLimit: 3, cacheExpiration: .seconds(5))
    }
    
    override func tearDownWithError() throws {
        <#code#>
    }
}
