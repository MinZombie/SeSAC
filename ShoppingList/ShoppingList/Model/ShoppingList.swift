//
//  ShoppingList.swift
//  ShoppingList
//
//  Created by 민선기 on 2021/10/14.
//

import Foundation

struct ShoppingList: Codable {
    var item: String
    var isChecking: Bool = false
    var isFavorite: Bool = false
    

}
