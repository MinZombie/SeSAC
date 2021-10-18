//
//  WebViewController.swift
//  TrendMedia
//
//  Created by 민선기 on 2021/10/18.
//

import UIKit

class WebViewController: UIViewController {
    
    var tvShowTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("WebViewController did load")
        title  = tvShowTitle
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
