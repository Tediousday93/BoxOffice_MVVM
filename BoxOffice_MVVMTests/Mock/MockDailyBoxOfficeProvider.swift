//
//  MockDailyBoxOfficeProvider.swift
//  BoxOffice_MVVMTests
//
//  Created by Rowan on 5/9/24.
//

import Foundation
@testable import BoxOffice_MVVM

final class MockDailyBoxOfficeProvider: DailyBoxOfficeProvidable {
    var getDailyCallCount: Int = .zero
    var willThrowNetworkError: Bool = false
    
    func getDaily(targetDate: String, completion: @escaping (Result<BoxOffice_MVVM.DailyBoxOffice, any Error>) -> Void) {
        
        if willThrowNetworkError {
            completion(.failure(NetworkError.unknown))
            return
        }
        
        getDailyCallCount += 1
        
        let daily = try! JSONDecoder().decode(DailyBoxOffice.self, from: MockData.dailyBoxOffice)
        completion(.success(daily))
    }
}
