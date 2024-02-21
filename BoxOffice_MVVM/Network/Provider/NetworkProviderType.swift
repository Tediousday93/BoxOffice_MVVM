//
//  NetworkProviderType.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/02/20.
//

import Foundation

protocol NetworkProviderType {
    associatedtype API: APIConfigurationType
    
    func request(_ api: API)
}
