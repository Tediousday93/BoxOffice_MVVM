//
//  MovieDetailsViewModelTest.swift
//  BoxOffice_MVVMTests
//
//  Created by Rowan on 5/10/24.
//

import XCTest
@testable import BoxOffice_MVVM

final class MovieDetailsViewModelTest: XCTestCase {
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter
    }()
    
    private var sut: MovieDetailsViewModel!
    private var mockMovieDetailsProvider: MockMovieDetailsProvider!
}
