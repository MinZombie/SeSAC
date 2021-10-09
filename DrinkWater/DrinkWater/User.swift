//
//  User.swift
//  DrinkWater
//
//  Created by 민선기 on 2021/10/09.
//

import Foundation

struct User: Codable {
    var nickname: String
    var height: Float
    var weight: Float
    var state: State
    
    enum State: String, Codable {
        case hasInfo
    }
}
