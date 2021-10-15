//
//  ViewController.swift
//  ShoppingList
//
//  Created by 민선기 on 2021/10/13.
//

// 할 것

// 셀 안에 button 클릭 했을 때 Bool 값 한번만 바뀜 = 메서드 안에 변수를 저장하고 그 변수를 토글해서 변수의 값만 바뀐 것. 

import UIKit

class ShoppingListViewController: UIViewController {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor(named: "background")
        setUpView()
        Manager.shared.request()
    }
    
    private func setUpView() {
        viewContainer.backgroundColor = UIColor(named: "background")
        
        titleLabel.text = "쇼핑"
        titleLabel.font = .boldSystemFont(ofSize: 21)
        titleLabel.textAlignment = .center
        
        textField.placeholder = "무엇을 구매하실 건가요"
        textField.backgroundColor = .systemGroupedBackground
        
        addButton.setTitle("추가", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        addButton.layer.cornerRadius = 4
        addButton.backgroundColor = UIColor(named: "cell_background")
        addButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
    }
    
    @objc func didTapAddButton() {
        Manager.shared.save(textField: textField, tableView: tableView)
        
        textField.text = ""

    }
}

extension ShoppingListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Manager.shared.list.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ShoppingListTableViewCell.identifier, for: indexPath) as? ShoppingListTableViewCell else {
            return UITableViewCell()
        }
        
        let list = Manager.shared.list[indexPath.row]
        
        cell.backgroundColor = UIColor(named: "cell_background")
        cell.delegate = self
        cell.index = indexPath.row
        
        cell.label.text = list.item

        if list.isChecking {
            cell.leftButton.tintColor = UIColor.red
            cell.leftButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .highlighted)
        } else {
            cell.leftButton.tintColor = UIColor(named: "check")
            cell.leftButton.setImage(UIImage(systemName: "checkmark.square"), for: .highlighted)
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)

    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Manager.shared.delete(indexPath: indexPath, tableView: tableView)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

}

extension ShoppingListViewController: TableViewCellDelegate {
    func didTapLeftButton(index: Int) {
        print(Manager.shared.list[index].isChecking)
        Manager.shared.list[index].isChecking.toggle()
        Manager.shared.update(tableView: tableView)
    }
}
