//
//  CalendarViewModel.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/04/22.
//

import Foundation

final class CalendarViewModel {
    private let currentDate: Observable<String>

    private let dateFormatter: DateFormatter
    
    init(
        currentDate: Observable<String>,
        dateFormatter: DateFormatter
    ) {
        self.currentDate = currentDate
        self.dateFormatter = dateFormatter
    }
    
    var availableDateRange: DateInterval? {
        if let startDate = dateFormatter.date(from: Constant.dailyBoxOfficeStartDate) {
            return DateInterval(start: startDate, end: DateConstant.yesterday)
        }
        return nil
    }
    
    var currentDateComponents: DateComponents? {
        if let currentDate = currentDate.value,
           let date = dateFormatter.date(from: currentDate) {
            return dateComponents(of: date)
        }
        
        return nil
    }
    
    func setCurrentDate(_ date: Date) {
        let dateString = dateFormatter.string(from: date)
        currentDate.value = dateString
    }
    
    private func dateComponents(of date: Date) -> DateComponents {
        let dateComponents = dateFormatter.string(from: date)
            .components(separatedBy: "-")
            .compactMap { Int($0) }
        
        return DateComponents(year: dateComponents[0],
                              month: dateComponents[1],
                              day: dateComponents[2])
    }
}

extension CalendarViewModel {
    private enum Constant {
        static let dailyBoxOfficeStartDate = "2003-11-11"
    }
}
