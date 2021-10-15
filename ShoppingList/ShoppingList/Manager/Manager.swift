//
//  Model.swift
//  ShoppingList
//
//  Created by 민선기 on 2021/10/14.
//

import Foundation
import UIKit

final class Manager {
    static let shared = Manager()
    
    private init() {}
    
    struct Constants {
        static let userDefaultsKey = "USERDEFAULTS_KEY"
    }
    
    var list: [ShoppingList] = []
     
    // MARK: - Public
    public func save(textField: UITextField, tableView: UITableView) {
        guard let text = textField.text else { return }
        list.append(ShoppingList(item: text))
        
        textField.text = ""
        
        update(tableView: tableView)
    }
    
    public func request() {
        guard let data = UserDefaults.standard.object(forKey: Constants.userDefaultsKey) as? Data else {
            return
        }
        do {
            
            let result = try JSONDecoder().decode([ShoppingList].self, from: data)
            self.list = result
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func delete(indexPath: IndexPath, tableView: UITableView) {
        list.remove(at: indexPath.row)
        update(tableView: tableView)
        
    }
    
    public func update(tableView: UITableView) {
        if let encoded = try? JSONEncoder().encode(list) {
            
            UserDefaults.standard.setValue(encoded, forKey: Constants.userDefaultsKey)
        }
        tableView.reloadData()
    }
}
