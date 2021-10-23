//
//  ViewController.swift
//  AutoLayout_or_die
//
//  Created by 민선기 on 2021/10/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var bottomViewContainer: UIView!
    @IBOutlet weak var profileImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: bottomViewContainer.frame.size.width, height: 0.5)
        layer.backgroundColor = UIColor.white.cgColor
        bottomViewContainer.layer.addSublayer(layer)
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        
    }

//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        let layer = CALayer()
//        layer.frame = CGRect(x: 0, y: 0, width: bottomViewContainer.frame.size.width, height: 0.5)
//        layer.backgroundColor = UIColor.white.cgColor
//        bottomViewContainer.layer.addSublayer(layer)
//    }
}

