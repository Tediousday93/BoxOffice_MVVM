//
//  DailyBoxOfficeListItem.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/04/16.
//

import Foundation
import UIKit.UIColor

final class DailyBoxOfficeListCellItem: Identifiable {
    let id: UUID = .init()
    
    let movie: DailyBoxOfficeMovie
    
    let numberFormatter: NumberFormatter
    
    init(movie: DailyBoxOfficeMovie, numberFormatter: NumberFormatter) {
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
                let text = Sign.down + difference
                return addPrefixColorAttribute(to: text, color: .systemBlue)
            } else if movie.rankDifference == Sign.zero {
                return Sign.minus
            } else {
                let text = Sign.up + movie.rankDifference
                return addPrefixColorAttribute(to: text, color: .systemRed)
            }
        }
    }
}

extension DailyBoxOfficeListCellItem {
    private func addPrefixColorAttribute(to text: String, color: UIColor) -> String {
        let mutableText = NSMutableAttributedString(string: text)
        let prefix = String(text.prefix(1))
        let range = NSString(string: text).range(of: prefix)
        
        mutableText.addAttribute(.foregroundColor, value: color, range: range)
        
        return mutableText.string
    }
    
    private enum Sign {
        static let newMovie = "신작"
        static let minus = "-"
        static let zero = "0"
        static let down = "⏷"
        static let up = "⏶"
    }
}
