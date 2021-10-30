//
//  Genre.swift
//  TrendMedia
//
//  Created by 민선기 on 2021/10/29.
//

import Foundation

struct Genres: Codable {
    var genres: [Genre]
}

struct Genre: Codable {
    var id: Int
    var name: String
}
