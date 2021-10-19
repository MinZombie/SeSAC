//
//  CategoryTableViewCell.swift
//  TrendMedia
//
//  Created by 민선기 on 2021/10/19.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    static let identifier = "CategoryTableViewCell"
    
    @IBOutlet weak var libraryButton: UIButton!
    @IBOutlet weak var filmButton: UIButton!
    @IBOutlet weak var tvButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = .red
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
