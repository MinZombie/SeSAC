//
//  ViewController.swift
//  WantToBeRich
//
//  Created by 민선기 on 2021/10/25.
//

import UIKit

/*
 자동으로 최신 회차 구하는 방법?
    - 로또시작한 날부터 지금까지 날짜 이용해서?
 */

class LotteryViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var inputNumberTextField: UITextField!
    @IBOutlet weak var guideView: UIView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet var lotteryNumbers: [UILabel]!
    
    let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo="
    
    var pickerView = UIPickerView()
    
    let pickerViewRows = Array(1...986)
    

    
    var numbers: Result? {
        didSet {
            DispatchQueue.main.async {
                self.resultLabel.text = "\(self.numbers?.drwNo ?? 0)"
                self.date.text = self.numbers?.drwNoDate
                self.lotteryNumbers[0].text = "\(self.numbers?.drwtNo1 ?? 0)"
                self.lotteryNumbers[1].text = "\(self.numbers?.drwtNo2 ?? 0)"
                self.lotteryNumbers[2].text = "\(self.numbers?.drwtNo3 ?? 0)"
                self.lotteryNumbers[3].text = "\(self.numbers?.drwtNo4 ?? 0)"
                self.lotteryNumbers[4].text = "\(self.numbers?.drwtNo5 ?? 0)"
                self.lotteryNumbers[5].text = "\(self.numbers?.drwtNo6 ?? 0)"
                self.lotteryNumbers[6].text = "\(self.numbers?.bnusNo ?? 0)"
                
                
            }
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputNumberTextField.inputView = pickerView
        inputNumberTextField.delegate = self
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: guideView.bounds.size.height , width: guideView.bounds.size.width, height: 0.5)
        layer.backgroundColor = UIColor.lightGray.cgColor
        guideView.layer.addSublayer(layer)
        
        request(url: url + "\(986)")
    }

    // MARK: - Private
    private func request(url: String) {
        guard let url = URL(string: url) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else { return}
            
            
            do {
                self.numbers  = try JSONDecoder().decode(Result.self, from: data)
                
                
            } catch {
                print(error)
            }
        }
        dataTask.resume()
    }
}

extension LotteryViewController: UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // DatePicker methods...
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 986
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(pickerViewRows[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("row : \(row)")
        request(url: url + "\(row + 1)")
    }
    

}
