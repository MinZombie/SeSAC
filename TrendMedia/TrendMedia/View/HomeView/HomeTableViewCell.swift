//
//  HomeTableViewCell.swift
//  TrendMedia
//
//  Created by 민선기 on 2021/10/15.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    static let identifier = "HomeTableViewCell"
    
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var rate: UILabel!
    
    @IBOutlet weak var disclosureIcon: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        disclosureIcon.tintColor = .black
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 26, left: 26, bottom: 26, right: 26))
        contentView.layer.borderWidth = 0.2
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.cornerRadius = 12
        
        
    }

}
