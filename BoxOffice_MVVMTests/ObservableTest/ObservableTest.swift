//
//  ObservableTest.swift
//  BoxOffice_MVVMTests
//
//  Created by Rowan on 5/9/24.
//

import XCTest
@testable import BoxOffice_MVVM

class ObservableTest: XCTestCase {
    var sut: Observable<Int>!
    var listener: ((Int) -> Void)!
    var expectation: XCTestExpectation!
    var emittedValues: [Int]!
    
    override func setUp() {
        sut = .init()
        listener = { [weak self] value in
            guard let self = self else { return }
            emittedValues.append(value)
        }
        emittedValues = []
        expectation = expectation(description: "Observable test expectation")
    }
    
    override func tearDown() {
        sut = nil
        listener = nil
        emittedValues = nil
        expectation = nil
    }
    
    func test_subscribeAndEmitValues() {
        sut.subscribe(listener: listener)
        
        var fireCount = 0.0
        let scheduler = Timer.scheduledTimer(
            withTimeInterval: 0.1,
            repeats: true
        ) { timer in
            fireCount += 1
            self.sut.value = Int(timer.timeInterval * fireCount * 10)
        }
        
        delay(0.3) { scheduler.invalidate() }
        delay(0.35) { [self] in
            XCTAssertEqual(emittedValues.count, 3)
            XCTAssertEqual(emittedValues[0], 1)
            XCTAssertEqual(emittedValues[1], 2)
            XCTAssertEqual(emittedValues[2], 3)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    func test_emitValueWhenSubscribed() {
        sut.value = 3
        
        sut.subscribe(listener: listener)
        
        delay(0.01) { [self] in
            XCTAssertEqual(emittedValues.first!, 3)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_multipleSubscribe() {
        sut.subscribe(listener: listener)
        sut.subscribe(listener: listener)
        sut.subscribe(listener: listener)
        
        var fireCount = 0.0
        let scheduler = Timer.scheduledTimer(
            withTimeInterval: 0.1,
            repeats: true
        ) { timer in
            fireCount += 1
            self.sut.value = Int(timer.timeInterval * fireCount * 10)
        }
            
        delay(0.2) { scheduler.invalidate() }
        delay(0.25) { [self] in
            XCTAssertEqual(emittedValues.count, 6)
            for index in 0...2 {
                XCTAssertEqual(emittedValues[index], 1)
            }
            for index in 3...5 {
                XCTAssertEqual(emittedValues[index], 2)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.5)
    }
}
