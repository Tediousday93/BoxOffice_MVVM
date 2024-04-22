//
//  DailyBoxOfficeViewModel.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/04/16.
//

import Foundation

final class DailyBoxOfficeViewModel {
    let dailyBoxOfficeItems: Observable<[DailyBoxOfficeListCellItem]> = .init()
    let currentDate: Observable<String> = .init()
    let thrownError: Observable<Error> = .init()
    
    private let boxOffice: DailyBoxOfficeProvidable
    
    private let numberFormatter: NumberFormatter
    
    private let dateFormatter: DateFormatter
    
    init(
        boxOffice: DailyBoxOfficeProvidable,
        numberFormatter: NumberFormatter,
        dateFormatter: DateFormatter
    ) {
        self.boxOffice = boxOffice
        self.numberFormatter = numberFormatter
        self.dateFormatter = dateFormatter
        
        setUpBindings()
        setCurrentDate(dateString(from: DateConstant.yesterday))
    }
    
    private func setUpBindings() {
        currentDate.subscribe { [weak self] date in
            let targetDate = date.replacingOccurrences(of: "-", with: "")
            self?.fetchDailyBoxOffice(targetDate: targetDate)
        }
    }
    
    private func fetchDailyBoxOffice(targetDate: String) {
        boxOffice.getDaily(targetDate: targetDate) { result in
            switch result {
            case let .success(dailyBoxOffice):
                let items = dailyBoxOffice.boxOfficeResult.dailyBoxOfficeList
                    .map {
                        DailyBoxOfficeListCellItem(movie: $0, numberFormatter: self.numberFormatter)
                    }
                
                self.dailyBoxOfficeItems.value = items
            case let .failure(error):
                self.thrownError.value = error
            }
        }
    }
    
    private func dateString(from date: Date) -> String {
        dateFormatter.string(from: DateConstant.yesterday)
    }
    
    func setCurrentDate(_ date: String) {
        currentDate.value = date
    }
}
