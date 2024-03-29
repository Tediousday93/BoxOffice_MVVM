//
//  Expiration.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/03/28.
//

import Foundation

enum CacheExpiration {
    case seconds(TimeInterval)
    
    case days(Int)
    
    func estimatedExpirationSince(_ date: Date) -> Date {
        switch self {
        case .seconds(let seconds):
            return date.addingTimeInterval(seconds)
        case .days(let days):
            let duration = TimeInterval(3600 * 24 * days)
            return date.addingTimeInterval(duration)
        }
    }
}

enum ExpirationExtending {
    case none
    
    case extend(CacheExpiration)
}
