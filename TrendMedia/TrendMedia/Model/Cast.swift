//
//  Cast.swift
//  TrendMedia
//
//  Created by 민선기 on 2021/10/31.
//

import Foundation

struct CastResponse: Codable {
    var cast: [Cast]
    var id: Int
}

struct Cast: Codable {
    var name: String
    var character: String
    var profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case character
        case profilePath = "profile_path"
    }
}
