//
//  ShoppingListTableViewCell.swift
//  ShoppingList
//
//  Created by 민선기 on 2021/10/13.
//

import UIKit

protocol ShoppingListTableViewCellDelegate: AnyObject {
    func checkButtonTapped(index: IndexPath)
    func likeButtonTapped(index: IndexPath)
}

class ShoppingListTableViewCell: UITableViewCell {
    
    static let identifier = "ShoppingListViewCell"
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var label: UILabel!
    
    var delegate: ShoppingListTableViewCellDelegate?
    var index: IndexPath = IndexPath()

    override func awakeFromNib() {
        super.awakeFromNib()
       
        label.textColor = .white
        
        leftButton.addTarget(self, action: #selector(didTapCheckButon), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setUpButtonImage() {
        
    }
    
    @objc func didTapCheckButon() {
        delegate?.checkButtonTapped(index: index)
    }
    
    @objc func didTapLikeButton() {
        delegate?.likeButtonTapped(index: index)
    }

}
