//
//  DateConstant.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/04/22.
//

import Foundation

enum DateConstant {
    static let secondsOfOneDay: TimeInterval = 3600 * 24
    static let yesterday = Date(timeIntervalSinceNow: -DateConstant.secondsOfOneDay)
}
