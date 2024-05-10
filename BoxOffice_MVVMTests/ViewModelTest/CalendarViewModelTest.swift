//
//  CalendarViewModelTest.swift
//  BoxOffice_MVVMTests
//
//  Created by Rowan on 5/10/24.
//

import XCTest
@testable import BoxOffice_MVVM

final class CalendarViewModelTest: XCTestCase {
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter
    }()
    
    private var sut: CalendarViewModel!
    private var currentDate: Observable<String>!
    private var year: Int!
    private var month: Int!
    private var day: Int!
    
    override func setUp() {
        let date = dateFormatter.string(from: .now)
        let dateComponents = date.split(separator: "-")
            .map(String.init)
            .compactMap { Int($0) }
        year = dateComponents[0]
        month = dateComponents[1]
        day = dateComponents[2]
        currentDate = .init(date)
        sut = .init(currentDate: currentDate,
                    dateFormatter: dateFormatter)
    }
    
    override func tearDown() {
        currentDate = nil
        sut = nil
    }
    
    func test_currentDateComponents() {
        let expectedDateComponents = DateComponents(year: year, month: month, day: day)
        
        let currentDateComponents = sut.currentDateComponents
        
        XCTAssertEqual(expectedDateComponents, currentDateComponents)
    }
    
    func test_setCurrentDate() {
        let date = Date.now
        let dateString = dateFormatter.string(from: date)
        
        sut.setCurrentDate(date)
        
        XCTAssertNotNil(currentDate.value)
        XCTAssertEqual(currentDate.value!, dateString)
    }
}
