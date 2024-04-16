//
//  DailyBoxOffice.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/02/21.
//

import Foundation

struct DailyBoxOffice: Decodable {
    let boxOfficeResult: BoxOfficeResult
}

struct BoxOfficeResult: Decodable {
    let boxOfficeType: String
    let showRange: String
    let dailyBoxOfficeList: [DailyBoxOfficeMovie]
    
    private enum CodingKeys: String, CodingKey {
        case showRange, dailyBoxOfficeList
        case boxOfficeType = "boxofficeType"
    }
}

struct DailyBoxOfficeMovie: Decodable {
    let rankNumber: String
    let rank: String
    let rankDifference: String
    let rankOldAndNew: RankOldAndNew
    let movieCode: String
    let movieName: String
    let openDate: String
    let salesAmount: String
    let salesShare: String
    let salesDifference: String
    let salesChangeRatio: String
    let salesAccumulate: String
    let audienceCountOfDate: Int
    let audienceDifferenceFromYesterday: String
    let audienceChangeRatio: String
    let accumulatedAudienceCount: Int
    let screenCount: String
    let showCount: String
    
    private enum CodingKeys: String, CodingKey {
        case rank, rankOldAndNew, salesShare
        case rankNumber = "rnum"
        case rankDifference = "rankInten"
        case movieCode = "movieCd"
        case movieName = "movieNm"
        case openDate = "openDt"
        case salesAmount = "salesAmt"
        case salesDifference = "salesInten"
        case salesChangeRatio = "salesChange"
        case salesAccumulate = "salesAcc"
        case audienceCountOfDate = "audiCnt"
        case audienceDifferenceFromYesterday = "audiInten"
        case audienceChangeRatio = "audiChange"
        case accumulatedAudienceCount = "audiAcc"
        case screenCount = "scrnCnt"
        case showCount = "showCnt"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.rank = try container.decode(String.self, forKey: .rank)
        self.rankOldAndNew = try container.decode(RankOldAndNew.self, forKey: .rankOldAndNew)
        self.salesShare = try container.decode(String.self, forKey: .salesShare)
        self.rankNumber = try container.decode(String.self, forKey: .rankNumber)
        self.rankDifference = try container.decode(String.self, forKey: .rankDifference)
        self.movieCode = try container.decode(String.self, forKey: .movieCode)
        self.movieName = try container.decode(String.self, forKey: .movieName)
        self.openDate = try container.decode(String.self, forKey: .openDate)
        self.salesAmount = try container.decode(String.self, forKey: .salesAmount)
        self.salesDifference = try container.decode(String.self, forKey: .salesDifference)
        self.salesChangeRatio = try container.decode(String.self, forKey: .salesChangeRatio)
        self.salesAccumulate = try container.decode(String.self, forKey: .salesAccumulate)
        self.audienceDifferenceFromYesterday = try container.decode(String.self, forKey: .audienceDifferenceFromYesterday)
        self.audienceChangeRatio = try container.decode(String.self, forKey: .audienceChangeRatio)
        self.screenCount = try container.decode(String.self, forKey: .screenCount)
        self.showCount = try container.decode(String.self, forKey: .showCount)
        
        let audienceCountOfDate = try container.decode(String.self, forKey: .audienceCountOfDate)
        let accumulatedAudienceCount = try container.decode(String.self, forKey: .accumulatedAudienceCount)
        
        guard let audienceCountOfDate = Int(audienceCountOfDate) else {
            throw DecodingError.dataCorrupted(
                .init(codingPath: [CodingKeys.audienceCountOfDate],
                      debugDescription: "Failed transforming audienceCount type String to Int")
            )
        }
        
        guard let accumulatedAudienceCount = Int(accumulatedAudienceCount) else {
            throw DecodingError.dataCorrupted(
                .init(codingPath: [CodingKeys.audienceCountOfDate],
                      debugDescription: "Failed transforming accumulatedAudienceCount type String to Int")
            )
        }
        
        self.audienceCountOfDate = audienceCountOfDate
        self.accumulatedAudienceCount = accumulatedAudienceCount
    }
}

enum RankOldAndNew: String, Decodable {
    case new = "NEW"
    case old = "OLD"
}
