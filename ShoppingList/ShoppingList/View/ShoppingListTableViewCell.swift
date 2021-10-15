//
//  ShoppingListTableViewCell.swift
//  ShoppingList
//
//  Created by 민선기 on 2021/10/13.
//

import UIKit

protocol TableViewCellDelegate: AnyObject {
    func didTapLeftButton(index: Int)
}

class ShoppingListTableViewCell: UITableViewCell {
    
    static let identifier = "ShoppingListViewCell"
    
    weak var delegate: TableViewCellDelegate?
    var index = 0
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        leftButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        leftButton.imageView?.tintColor = UIColor(named: "check")
        
        rightButton.setImage(UIImage(systemName: "star"), for: .normal)
        rightButton.imageView?.tintColor = UIColor(named: "star")
        
        leftButton.addTarget(self, action: #selector(didTapLeftButton), for: .touchUpInside)
       
        label.textColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setUpButtonImage() {
        
    }
    
    @objc func didTapLeftButton() {
        delegate?.didTapLeftButton(index: index)
    }

}
