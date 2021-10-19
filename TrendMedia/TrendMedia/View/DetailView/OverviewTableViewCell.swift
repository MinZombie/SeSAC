//
//  StoryTableViewCell.swift
//  TrendMedia
//
//  Created by 민선기 on 2021/10/19.
//

import UIKit

class OverviewTableViewCell: UITableViewCell {
    
    static let identifier = "OverviewTableViewCell"
    
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var expandButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        expandButton.tintColor = .black 
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
