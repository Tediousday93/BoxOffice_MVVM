//
//  DailyBoxOfficeViewModel.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/04/16.
//

import Foundation

final class DailyBoxOfficeViewModel {
    let dailyBoxOfficeMovies: Observable<[DailyBoxOfficeListCellItem]> = .init([])
    let thrownError: Observable<Error?> = .init(nil)
    
    private let boxOffice: BoxOfficeType
    
    private let numberFormatter: NumberFormatter
    
    init(
        boxOffice: BoxOfficeType,
        numberFormatter: NumberFormatter
    ) {
        self.boxOffice = boxOffice
        self.numberFormatter = numberFormatter
    }
    
    func fetchDailyBoxOffice(targetDate: String) {
        boxOffice.getDaily(targetDate: targetDate) { result in
            switch result {
            case let .success(dailyBoxOffice):
                let items = dailyBoxOffice.boxOfficeResult.dailyBoxOfficeList
                    .map {
                        DailyBoxOfficeListCellItem(movie: $0, numberFormatter: self.numberFormatter)
                    }
                
                self.dailyBoxOfficeMovies.value = items
            case let .failure(error):
                self.thrownError.value = error
            }
        }
    }
}
