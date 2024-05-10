//
//  DailyBoxOfficeViewModelTest.swift
//  BoxOffice_MVVMTests
//
//  Created by Rowan on 5/9/24.
//

import XCTest
@testable import BoxOffice_MVVM

class DailyBoxOfficeViewModelTest: XCTestCase {
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        return formatter
    }()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter
    }()
    
    var sut: DailyBoxOfficeViewModel!
    var mockDailyBoxOfficeProvider: MockDailyBoxOfficeProvider!
    
    var emittedCellItems: [DailyBoxOfficeCellItem]?
    var emittedDate: String?
    var emittedMode: DailyBoxOfficeViewModel.CollectionViewMode?
    
    override func setUp() {
        mockDailyBoxOfficeProvider = .init()
        sut = .init(boxOffice: mockDailyBoxOfficeProvider,
                    numberFormatter: numberFormatter,
                    dateFormatter: dateFormatter)
    }
    
    override func tearDown() {
        mockDailyBoxOfficeProvider = nil
        sut = nil
        emittedCellItems = nil
        emittedDate = nil
        emittedMode = nil
    }
    
    func test_initialValueOfCurrentDateIsYesterday() {
        let yesterday = dateFormatter.string(from: DateConstant.yesterday)
        XCTAssertNotNil(sut.currentDate.value)
        XCTAssertEqual(sut.currentDate.value!, yesterday)
    }
    
    func test_fetchDailyBoxOfficeCalledAfterInitialized() {
        let firstMovieName = "미션임파서블:고스트프로토콜"
        let items = sut.dailyBoxOfficeItems.value!
        
        XCTAssertEqual(mockDailyBoxOfficeProvider.getDailyCallCount, 1)
        XCTAssertEqual(items.count, 10)
        XCTAssertEqual(items.first!.movieTitle, firstMovieName)
    }
    
    func test_setCurrentDate() {
        let date = dateFormatter.string(from: Date(timeIntervalSinceNow: 60))
        
        sut.setCurrentDate(date)
        
        XCTAssertEqual(sut.currentDate.value!, date)
        XCTAssertEqual(mockDailyBoxOfficeProvider.getDailyCallCount, 2)
    }
    
    func test_fetchDailyBoxOfficeFailure() {
        mockDailyBoxOfficeProvider.willThrowNetworkError = true
        let date = dateFormatter.string(from: .now)
        
        sut.setCurrentDate(date)
        
        XCTAssertNotNil(sut.thrownError.value)
        guard let error = sut.thrownError.value as? NetworkError else {
            XCTFail("fetch method must throw error here")
            return
        }
        XCTAssertEqual(error, NetworkError.unknown)
    }
    
    func test_changeCollectionViewMode() {
        XCTAssertNotNil(sut.collectionViewMode.value)
        XCTAssertEqual(sut.collectionViewMode.value!, .list)
        
        sut.changeCollectionViewMode()
        XCTAssertEqual(sut.collectionViewMode.value!, .icon)
        
        sut.changeCollectionViewMode()
        XCTAssertEqual(sut.collectionViewMode.value!, .list)
    }
    
    func test_enum_CollectionViewMode_list() {
        var mode: DailyBoxOfficeViewModel.CollectionViewMode = .list
        XCTAssertEqual(mode.buttonTitle, "리스트")
        
        mode = mode.toggle()
        
        XCTAssertEqual(mode, .icon)
        XCTAssertEqual(mode.buttonTitle, "아이콘")
    }
    
    func test_enum_CollectionViewMode_icon() {
        var mode: DailyBoxOfficeViewModel.CollectionViewMode = .icon
        XCTAssertEqual(mode.buttonTitle, "아이콘")
        
        mode = mode.toggle()
        
        XCTAssertEqual(mode, .list)
        XCTAssertEqual(mode.buttonTitle, "리스트")
    }
}
