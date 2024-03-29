//
//  NetworkProvider.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/02/23.
//

import Foundation

final class NetworkProvider {
    private let session: NetworkSessionType
    private let jsonDecoder: NetworkJSONDecodable
    private let jsonSerializer: NetworkJSONSerializable
    
    init(
        session: NetworkSessionType,
        jsonDecoder: NetworkJSONDecodable,
        jsonSerializer: NetworkJSONSerializable
    ) {
        self.session = session
        self.jsonDecoder = jsonDecoder
        self.jsonSerializer = jsonSerializer
    }
    
    func request<API: APIConfigurationType>(
        _ api: API,
        completion: @escaping (Result<API.Response, Error>) -> Void
    ) {
        do {
            let request = try makeRequest(for: api)
            session.dataTask(with: request) { result in
                switch result {
                case let .success(data):
                    do {
                        let response = try self.jsonDecoder.decode(data, to: API.Response.self)
                        completion(.success(response))
                    } catch {
                        completion(.failure(error))
                    }
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
}

extension NetworkProvider {
    private func makeRequest<API: APIConfigurationType>(for api: API) throws -> URLRequest {
        let fullPath = api.baseURL + api.path
        
        guard var urlComponents = URLComponents(string: fullPath) else {
            throw NetworkError.invalidURL
        }
        
        var queryItems: [URLQueryItem] = []
        api.queryParameters.forEach { (key, value) in
            queryItems.append(URLQueryItem(name: key, value: "\(value)"))
        }
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        
        api.headers.forEach { (key, value) in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        request.httpMethod = api.method.rawValue
        request.httpBody = try jsonSerializer.serialize(api.bodyParameters)
        
        return request
    }
}
