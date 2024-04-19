//
//  ImageProvider.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/03/08.
//

import Foundation
import UIKit.UIImage

enum ImageProviderError: Error, Equatable {
    case imageConvertingFail(imageURL: URL)
}

final class ImageProvider: ImageProviderType {
    private let cache: ImageCacheType
    private let loader: NetworkSessionType
    
    init(
        cache: ImageCacheType = ImageCache.default,
        loader: NetworkSessionType = NetworkSession(session: .init(configuration: .ephemeral))
    ) {
        self.cache = cache
        self.loader = loader
        
        try? cache.removeExpired(option: .disk)
    }
    
    func fetchImage(
        from url: URL,
        completion: @escaping (Result<UIImage, Error>) -> Void
    ) {
        do {
            if cache.isCached(for: url.cacheKey),
               let cachedImage = try cache.retrieveImage(for: url.cacheKey) {
                completion(.success(cachedImage))
                return
            }
        } catch {
            completion(.failure(error))
        }
        
        downloadImage(from: url) { result in
            switch result {
            case let .success(image):
                do {
                    try self.cache.store(image, for: url.cacheKey)
                    completion(.success(image))
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func downloadImage(
        from url: URL,
        completion: @escaping (Result<UIImage, Error>) -> Void
    ) {
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
        return self.path().replacingOccurrences(of: "/", with: "-")
    }
}
