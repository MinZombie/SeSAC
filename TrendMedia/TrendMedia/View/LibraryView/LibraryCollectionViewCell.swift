//
//  LibraryCollectionViewCell.swift
//  TrendMedia
//
//  Created by 민선기 on 2021/10/19.
//

import UIKit

class LibraryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "LibraryCollectionViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var poster: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = getRandomColor()
        contentView.layer.cornerRadius = 16
    }
    
    private func getRandomColor() -> UIColor{
        
        let randomRed:CGFloat = CGFloat.random(in: 0...1)
        
        let randomGreen:CGFloat = CGFloat.random(in: 0...1)
        
        let randomBlue:CGFloat = CGFloat.random(in: 0...1)
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }

}
