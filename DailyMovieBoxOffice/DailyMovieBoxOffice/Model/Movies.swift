//
//  Movies.swift
//  DailyMovieBoxOffice
//
//  Created by 민선기 on 2021/11/03.
//

import Foundation

struct MoviesResponse: Codable {
    let boxOfficeResult: DailyBoxOfficeList
    
    struct DailyBoxOfficeList: Codable {
        let dailyBoxOfficeList: [Movie]
    }
    
    struct Movie: Codable {
        let movieNm: String
    }
}
