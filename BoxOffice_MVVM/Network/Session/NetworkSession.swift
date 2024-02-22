//
//  NetworkSession.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/02/21.
//

import Foundation

final class NetworkSession: NetworkSessionType {
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func dataTask(
        with request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        let task = session.dataTask(with: request) { data, response, error in
            completion(self.checkError(for: data, response, error))
        }
        task.resume()
    }
    
    func dataTask(
        with url: URL,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        let task = session.dataTask(with: url) { data, response, error in
            completion(self.checkError(for: data, response, error))
        }
        task.resume()
    }
}

extension NetworkSession {
    private func checkError(
        for data: Data?,
        _ response: URLResponse?,
        _ error: Error?
    ) -> Result<Data, Error> {
        if let error {
            return .failure(error)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(NetworkError.responseNotFound)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            return .failure(
                NetworkError.invalidHttpStatusCode(statusCode: httpResponse.statusCode)
            )
        }
        
        guard let data else {
            return .failure(NetworkError.emptyData)
        }
        
        return .success(data)
    }
}
