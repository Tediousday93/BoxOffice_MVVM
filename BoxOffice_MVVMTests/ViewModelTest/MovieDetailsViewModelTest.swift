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
    
    private let (movieCode, movieTitle): (String, String) = {
        let movieDetails = try! JSONDecoder().decode(MovieDetails.self, from: MockData.movieDetails)
        return (movieDetails.movieInfoResult.movieInfo.movieCode,
                movieDetails.movieInfoResult.movieInfo.movieName)
    }()
    
    private var sut: MovieDetailsViewModel!
    private var mockMovieDetailsProvider: MockMovieDetailsProvider!
    private var mockImageURLSearcher: MockImageURLSearcher!
    
    override func setUp() {
        mockImageURLSearcher = .init()
        mockMovieDetailsProvider = .init()
        sut = .init(movieCode: movieCode,
                    movieTitle: movieTitle,
                    boxOffice: mockMovieDetailsProvider,
                    imageURLSearcher: mockImageURLSearcher,
                    dateFormatter: dateFormatter)
    }
    
    override func tearDown() {
        mockImageURLSearcher = nil
        mockMovieDetailsProvider = nil
        sut = nil
    }
    
    func test_searchImageURL_success() {
        XCTAssertEqual(mockImageURLSearcher.searchSingleCallCount, 1)
        XCTAssertNotNil(sut.posterURL.value)
        XCTAssertEqual(sut.posterURL.value!, mockImageURLSearcher.dummyURL)
    }
    
    func test_searchImageURL_failure() {
        mockImageURLSearcher.willThrowNetworkError = true
        
        sut = .init(movieCode: movieCode,
                    movieTitle: movieTitle,
                    boxOffice: mockMovieDetailsProvider,
                    imageURLSearcher: mockImageURLSearcher,
                    dateFormatter: dateFormatter)
        
        XCTAssertNotNil(sut.thrownError.value)
        guard let error = sut.thrownError.value as? NetworkError else {
            XCTFail("searchImageURL must throw error")
            return
        }
        XCTAssertEqual(error, NetworkError.unknown)
    }
    
    func test_fetchMovieInfo_success() {
        XCTAssertEqual(mockMovieDetailsProvider.getMovieDetailsCallCount, 1)
        XCTAssertNotNil(sut.movieDetailsItem.value)
        XCTAssertEqual(sut.movieDetailsItem.value!.openDate, "2012-09-13")
        XCTAssertEqual(sut.movieDetailsItem.value!.runningTime, "131분")
    }
    
    func test_fetchMovieInfo_failure() {
        mockMovieDetailsProvider.willThrowNetworkError = true
        
        sut = .init(movieCode: movieCode,
                    movieTitle: movieTitle,
                    boxOffice: mockMovieDetailsProvider,
                    imageURLSearcher: mockImageURLSearcher,
                    dateFormatter: dateFormatter)
        
        XCTAssertNotNil(sut.thrownError.value)
        guard let error = sut.thrownError.value as? NetworkError else {
            XCTFail("searchImageURL must throw error")
            return
        }
        XCTAssertEqual(error, NetworkError.unknown)
    }
}
