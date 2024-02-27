//
//  DaumImageSearcher.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/02/27.
//

import Foundation

final class DaumImageSearcher: ImageURLSearchable {
    private let provider: NetworkProvider
    
    init(provider: NetworkProvider) {
        self.provider = provider
    }
    
    func searchSingle(
        for keyword: String,
        completion: @escaping (Result<URL, Error>) -> Void
    ) {
        provider.request(
            DaumImageSearchAPI(queryParameters: .query(keyword: keyword))
        ) { result in
            switch result {
            case let .success(searchResult):
                guard let urlString = searchResult.documents.first?.imageURL,
                      let url = URL(string: urlString) else {
                    completion(.failure(ImageURLSearchError.URLNotFound))
                    return
                }
                completion(.success(url))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func search(
        for keyword: String,
        completion: @escaping (Result<[URL], Error>) -> Void
    ) {
        provider.request(
            DaumImageSearchAPI(queryParameters: .query(keyword: keyword))
        ) { result in
            switch result {
            case let .success(searchResult):
                let urls = searchResult.documents
                    .map { $0.imageURL }
                    .compactMap { URL(string: $0) }
                completion(.success(urls))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
