//
//  extension.swift
//  TrendMedia
//
//  Created by 민선기 on 2021/10/20.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String, message: String?, okTitle: String, okHandler: @escaping () -> ()) {
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okTitle, style: .default) { _ in
            okHandler()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        controller.addAction(okAction)
        controller.addAction(cancelAction)
        
        self.present(controller, animated: true, completion: nil)
    }
}
