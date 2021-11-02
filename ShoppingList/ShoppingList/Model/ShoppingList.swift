//
//  ShoppingList.swift
//  ShoppingList
//
//  Created by 민선기 on 2021/10/14.
//

import Foundation
import RealmSwift

class ShoppingList: Object {
    @Persisted var item: String
    @Persisted var isChecking: Bool = false
    @Persisted var isFavorite: Bool = false
    
    @Persisted(primaryKey: true) var _id: UUID
    
    convenience init(item: String) {
        self.init()
        self.item = item
    }
}
