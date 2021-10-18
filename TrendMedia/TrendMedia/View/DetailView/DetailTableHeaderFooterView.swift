//
//  DetailTableHeaderFooterView.swift
//  TrendMedia
//
//  Created by 민선기 on 2021/10/18.
//

import UIKit

class DetailTableHeaderFooterView: UITableViewHeaderFooterView {
    
    static let identifier = "DetailTableHeaderFooterView"
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
