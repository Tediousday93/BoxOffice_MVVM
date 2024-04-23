//
//  DailyBoxOfficeViewModel.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/04/16.
//

import Foundation

final class DailyBoxOfficeViewModel {
    let dailyBoxOfficeItems: Observable<[DailyBoxOfficeCellItem]> = .init()
    let currentDate: Observable<String> = .init()
    let collectionViewMode: Observable<CollectionViewMode> = .init(.list)
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
                        DailyBoxOfficeCellItem(movie: $0, numberFormatter: self.numberFormatter)
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
    
    func changeCollectionViewMode() {
        guard let mode = collectionViewMode.value else { return }
        
        switch mode {
        case .icon:
            collectionViewMode.value = .list
        case .list:
            collectionViewMode.value = .icon
        }
    }
}

extension DailyBoxOfficeViewModel {
    enum CollectionViewMode {
        case list
        case icon
        
        var buttonTitle: String {
            switch self {
            case .list:
                return "리스트"
            case .icon:
                return "아이콘"
            }
        }
        
        func toggle() -> Self {
            switch self {
            case .list:
                return .icon
            case .icon:
                return .list
            }
        }
    }
}
