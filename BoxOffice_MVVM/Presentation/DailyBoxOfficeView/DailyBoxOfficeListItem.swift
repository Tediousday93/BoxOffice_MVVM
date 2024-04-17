//
//  DailyBoxOfficeListItem.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/04/16.
//

import Foundation

final class DailyBoxOfficeListCellItem: Identifiable {
    let id: String
    
    let movie: DailyBoxOfficeMovie
    
    private let numberFormatter: NumberFormatter
    
    init(movie: DailyBoxOfficeMovie, numberFormatter: NumberFormatter) {
        self.id = movie.movieCode
        self.movie = movie
        self.numberFormatter = numberFormatter
    }
    
    var movieTitle: String {
        return movie.movieName
    }
    
    var audienceCount: String {
        let audienceCountOfDate = numberFormatter.string(from: movie.audienceCountOfDate as NSNumber) ?? Sign.zero
        let accumulatedAudience = numberFormatter.string(from: movie.accumulatedAudienceCount as NSNumber) ?? Sign.zero
        
        return "오늘 \(audienceCountOfDate) / 총 \(accumulatedAudience)"
    }
    
    var rank: String {
        return movie.rank
    }
    
    var rankOldAndNew: RankOldAndNew {
        return movie.rankOldAndNew
    }
    
    var rankDifference: String {
        switch movie.rankOldAndNew {
        case .new:
            return Sign.newMovie
        case .old:
            if movie.rankDifference.contains(Sign.minus) {
                let difference = movie.rankDifference.trimmingPrefix(Sign.minus)
                return Sign.down + difference
            } else if movie.rankDifference == Sign.zero {
                return Sign.minus
            } else {
                return Sign.up + movie.rankDifference
            }
        }
    }
}

extension DailyBoxOfficeListCellItem {
    private enum Sign {
        static let newMovie = "신작"
        static let minus = "-"
        static let zero = "0"
        static let down = "⏷"
        static let up = "⏶"
    }
}
