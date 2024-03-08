//
//  ImageProvider.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/03/08.
//

import Foundation
import UIKit.UIImage

enum ImageProviderError: Error {
    case imageConvertingFail(imageURL: URL)
}

final class ImageProvider {
    private let cache: ImageCache
    private let loader: NetworkSessionType
    
    init(
        cache: ImageCache = .default,
        loader: NetworkSessionType
    ) {
        self.cache = cache
        self.loader = loader
    }
    
    func fetchImage(
        from url: URL,
        completion: @escaping (Result<UIImage, Error>) -> Void
    ) throws {
        if try cache.isCached(for: url.cacheKey),
           let cachedImage = try cache.retrieveImage(for: url.cacheKey) {
            completion(.success(cachedImage))
        }
        
        loader.dataTask(with: url) { result in
            switch result {
            case let .success(data):
                guard let image = UIImage(data: data) else {
                    completion(.failure(ImageProviderError.imageConvertingFail(imageURL: url)))
                    return
                }
                completion(.success(image))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

extension URL {
    var cacheKey: String {
        return self.absoluteString
    }
}
