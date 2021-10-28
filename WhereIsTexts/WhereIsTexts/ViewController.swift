//
//  ViewController.swift
//  WhereIsTexts
//
//  Created by 민선기 on 2021/10/27.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var visionImageView: UIImageView!
    @IBOutlet weak var resultTextView: UITextView!
    
    
    var resultText = ""
    
    // x좌표 = 첫번째 배열값[0], y좌표 = 첫번째 배열감[1]
    // width = 두번째 배열[0] - x좌표
    // height = 세번째 배열[1] - y좌표

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func confirmButton(_ sender: UIButton) {
        APIManager.shared.request(image: visionImageView.image!) { json in
            
            for item in json["result"].arrayValue {
                
                
                for word in item["recognition_words"].arrayValue {
                    
                    self.resultText += word.stringValue + " "
                    
                }
                
            }
            print(json)
            
            self.resultTextView.text = self.resultText
        }
    }


}

