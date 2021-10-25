//
//  ViewController.swift
//  WantToBeRich
//
//  Created by 민선기 on 2021/10/25.
//

import UIKit

class LotteryViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var inputNumberTextField: UITextField!
    
    var pickerView = UIPickerView()
    
    let numbers = Array(1...9)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputNumberTextField.inputView = pickerView
        inputNumberTextField.delegate = self
        
        pickerView.dataSource = self
        pickerView.delegate = self
    }


}

extension LotteryViewController: UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numbers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numbers[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
    }
    
    
}
