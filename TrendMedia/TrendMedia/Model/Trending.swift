//
//  TvShow.swift
//  TrendMedia
//
//  Created by 민선기 on 2021/10/15.
//

import Foundation

struct TrendingResponse: Codable {
    let results: [Trending]
    let page: Int
    let totalResults: Int
    let totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case page
        case results
    }
}

struct Trending: Codable {
    let id: Int
    let genre: [Int]
    let overview: String
    let title: String
    let releaseDate: String
    let popularity: Double
    let backdropPath: String?
    let posterPath: String?
    
    enum CodingKeys: String, CodingKey {
        case genre = "genre_ids"
        case releaseDate = "release_date"
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
        case overview
        case title
        case popularity
        case id
    }
    
}

// 나중에 삭제
struct TvShow: Codable {
    let title: String
    let releaseDate: String
    let genre: String
    let region: String
    let overview: String
    let rate: Double
    let starring: String
    let backdropImage: String
}
