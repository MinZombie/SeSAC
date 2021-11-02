//
//  Model.swift
//  ShoppingList
//
//  Created by 민선기 on 2021/10/14.
//

import UIKit
import RealmSwift

final class Manager {
    static let shared = Manager()
    
    private init() {}
    
    struct Constants {
        static let userDefaultsKey = "USERDEFAULTS_KEY"
    }
    
    let localRealm = try! Realm()
    
    
    
    // MARK: - Public
    public func save(item: String) {
        let task = ShoppingList(item: item)
        try! localRealm.write {
            localRealm.add(task)
        }
    }
    
    public func read() -> Results<ShoppingList> {
        return localRealm.objects(ShoppingList.self)
    }
    
    public func delete(item: ShoppingList) {
        
        try! localRealm.write {
            localRealm.delete(item)
        }
    }
    
    public func updateCheckButton(index: IndexPath, tableView: UITableView) {
        try! localRealm.write {
            localRealm.objects(ShoppingList.self)[index.row].isChecking.toggle()
        }
        
        tableView.reloadRows(at: [index], with: .automatic)
    }
    
    public func updateFavoriteButton(index: IndexPath, tableView: UITableView) {
        try! localRealm.write {
            localRealm.objects(ShoppingList.self)[index.row].isFavorite.toggle()
        }
        
        tableView.reloadRows(at: [index], with: .automatic)
    }
}
