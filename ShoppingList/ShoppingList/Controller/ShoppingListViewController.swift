//
//  ViewController.swift
//  ShoppingList
//
//  Created by 민선기 on 2021/10/13.
//

import UIKit
import RealmSwift

class ShoppingListViewController: UIViewController {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var list: Results<ShoppingList>!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
        
        list = Manager.shared.read()
    }
    
    private func setUpView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor(named: "background")
        
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
        guard let text = textField.text else { return }
        Manager.shared.save(item: text)
        
        textField.text = ""
        tableView.reloadData()
    }
    
}

extension ShoppingListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ShoppingListTableViewCell.identifier, for: indexPath) as? ShoppingListTableViewCell else {
            return UITableViewCell()
        }
        
        let indexPathrow = indexPath.row
        let list = list[indexPathrow]
        
        // 셀 델리게이트에 관한 설정
        cell.index = indexPath
        cell.delegate = self
        
        cell.backgroundColor = UIColor(named: "cell_background")
        
        cell.label.text = list.item
        
        // 체크 상태값 이미지, 색상 변화
        if list.isChecking {
            cell.leftButton.tintColor = UIColor.red
            cell.leftButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
        } else {
            cell.leftButton.tintColor = UIColor(named: "check")
            cell.leftButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        }
        
        // 좋아요 상태값 이미지, 색상 변화
        if list.isFavorite {
            cell.rightButton.tintColor = UIColor.red
            cell.rightButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            cell.rightButton.tintColor = UIColor(named: "star")
            cell.rightButton.setImage(UIImage(systemName: "star"), for: .normal)
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
            Manager.shared.delete(item: list[indexPath.row])
            tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: indexPath.section)], with: .automatic)
            
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

}

extension ShoppingListViewController: ShoppingListTableViewCellDelegate {
    func checkButtonTapped(index: IndexPath) {
        Manager.shared.updateCheckButton(index: index, tableView: tableView)
    }
    
    func likeButtonTapped(index: IndexPath) {
        Manager.shared.updateFavoriteButton(index: index, tableView: tableView)
    }

}
