//
//  DaumSearchResult.swift
//  BoxOffice_MVVM
//
//  Created by Rowan on 2024/02/21.
//

import Foundation

struct DaumImageSearchResult: Decodable {
    let metadata: Metadata
    let documents: [Document]
    
    enum CodingKeys: String, CodingKey {
        case documents
        case metadata = "meta"
    }
}

struct Document: Decodable {
    let collection: String
    let thumbnailURL: String
    let imageURL: String
    let width, height: Int
    let displaySitename: String
    let documentURL: String
    let datetime: String

    enum CodingKeys: String, CodingKey {
        case collection
        case thumbnailURL = "thumbnail_url"
        case imageURL = "image_url"
        case width, height
        case displaySitename = "display_sitename"
        case documentURL = "doc_url"
        case datetime
    }
}

struct Metadata: Decodable {
    let totalCount, pageableCount: Int
    let isEnd: Bool

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case pageableCount = "pageable_count"
        case isEnd = "is_end"
    }
}
