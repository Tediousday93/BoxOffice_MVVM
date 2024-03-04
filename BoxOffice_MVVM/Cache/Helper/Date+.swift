//
//  Date+.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/03/04.
//

import Foundation

extension Date {
    func isPast(referenceDate: Date) -> Bool {
        self.timeIntervalSince(referenceDate) <= 0
    }
}
