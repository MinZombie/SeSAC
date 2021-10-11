//
//  ViewController.swift
//  DrinkWater
//
//  Created by 민선기 on 2021/10/08.
//

// 할 것
// 다 마셨을 때
// 네이밍? 리팩토링?

import UIKit

class MainViewController: UIViewController {
    // MARK: - Properties
    var user: User?
    var currentWater = UserDefaults.standard.float(forKey: Constants.UserDefaultsKeys.currentWater) {
        didSet {
            waterQuantity.text = "\(String(format: "%.0f", currentWater))ml"
            goalPercent.text = "\(percent(currentWater: currentWater))"
        }
    }
    let userNotification = UNUserNotificationCenter.current()
    
        
    @IBOutlet weak var reloadBarButton: UIBarButtonItem!
    @IBOutlet weak var profileBarButton: UIBarButtonItem!
    
    @IBOutlet weak var mainDescription: UILabel!
    @IBOutlet weak var waterQuantity: UILabel!
    @IBOutlet weak var goalPercent: UILabel!
    
    @IBOutlet weak var mainImageView: UIImageView!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var recommendLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        requestAuthorizationNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        request()

        switch user?.state {
        case .hasInfo:
            mainDescription.text = Constants.HasInfo.mainText
            waterQuantity.text = "\(String(format: "%.0f", currentWater))ml"
            goalPercent.text = "\(percent(currentWater: currentWater))"
            mainImageView.image = UIImage(named: "1-\(updateImage(percent: percent(currentWater: currentWater)))")
            
            recommendLabel.text = "\(user?.nickname ?? "")님의 하루 권장 섭취량은\(figureOutTotalWater(height: user?.height ?? 0, weight: user?.weight ?? 0))L 입니다."
            
        default:
            mainDescription.text = Constants.EmptyInfo.mainText
            recommendLabel.text = Constants.EmptyInfo.recommendText
            mainImageView.image = UIImage(named: "1-1")
            waterQuantity.text = ""
            goalPercent.text = ""
        }

        
    }
    
    // MARK: - Private
    private func setUpView() {
        view.backgroundColor = .systemTeal
        textField.delegate = self
        
        profileBarButton.image = UIImage(systemName: "person.circle")
        profileBarButton.tintColor = .white
        reloadBarButton.image = UIImage(systemName: "arrow.clockwise")
        reloadBarButton.tintColor = .white
        
        mainDescription.font = .systemFont(ofSize: 21, weight: .medium)
        mainDescription.textColor = .white
        
        waterQuantity.font = .systemFont(ofSize: 27, weight: .bold)
        waterQuantity.textColor = .white
        
        goalPercent.font = .systemFont(ofSize: 14, weight: .regular)
        goalPercent.textColor = .white
        
        textField.borderStyle = .none
        textField.keyboardType = .numberPad
        textField.font = .boldSystemFont(ofSize: 19)
        textField.placeholder = Constants.HasInfo.textFieldPlaceholder
        textField.textAlignment = .center
        
        
        recommendLabel.textAlignment = .center
        recommendLabel.font = . systemFont(ofSize: 14, weight: .regular)
        recommendLabel.textColor = .white
        
        
        confirmButton.setTitle(Constants.HasInfo.confirmText, for: .normal)
        confirmButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        confirmButton.backgroundColor = .white
        confirmButton.addTarget(self, action: #selector(didTapConfirmButton(_:)), for: .touchUpInside)
        
        
        reloadBarButton.target = self
        reloadBarButton.action = #selector(didTapReloadButton(_:))
       
    }
    
    private func request() {
        guard let data = UserDefaults.standard.object(forKey: Constants.UserDefaultsKeys.userDefault) as? Data else { return }
        
        do {
            let result = try JSONDecoder().decode(User.self, from: data)
            self.user = result
        } catch {
            print(error.localizedDescription)
        }
    }

    private func drinkWater() {
        guard let water = textField.text else {
            return
        }
        currentWater += Float(water) ?? 0
        UserDefaults.standard.set(currentWater, forKey: Constants.UserDefaultsKeys.currentWater)
        
        waterQuantity.text = "\(String(format: "%.0f", currentWater))ml"
        goalPercent.text = "\(percent(currentWater: currentWater))"
        mainImageView.image = UIImage(named: "1-\(updateImage(percent: percent(currentWater: currentWater)))")
        
        textField.text = ""
    }
    
    private func figureOutTotalWater(height: Float, weight: Float) -> Float {
        var result: Float = 0
        result = (height + weight) / 100
        
        return result
    }

    private func percent(currentWater: Float) -> String {
        let total = figureOutTotalWater(height: user?.height ?? 0, weight: user?.weight ?? 0)

        return "목표의 \(String(format: "%.0f", currentWater / ((total * 1000)) * 100))%"
    }

    private func updateImage(percent: String) -> Int {

        let photoNumber = percent.filter { $0.isNumber }
        
        return Int(photoNumber) ?? 0 >= 90 ? 9 : ((Int(photoNumber) ?? 0) / 10) + 1
    }
    
    private func requestAuthorizationNotification() {

        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
        
        userNotification.requestAuthorization(options: authOptions) { success, error in
            
            if success {
                self.sendNotification()
                
            } else {
                if let error = error {
                    print(#function, error)
                }
            }
        }
    }
    
    private func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "물 마실 시간입니다 🤩"
        content.body = "오늘도 화이팅!!"
        
        var dateComponents = DateComponents()
        dateComponents.hour = 6
        dateComponents.hour = 30
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        // UUID는 매번 같은 값을 리턴. 앱 삭제 후 재설치하면 새로운 값
        let request = UNNotificationRequest(identifier: "\(Date())", content: content, trigger: trigger)
        
        userNotification.add(request) { error in
            if let error = error {
                print(#function, error)
            }
        }
    }
    
    @objc func didTapConfirmButton(_ sender: UIButton) {
        drinkWater()
    }
    
    @objc func didTapReloadButton(_ sender: UIButton) {
        currentWater = 0
        UserDefaults.standard.set(0.0, forKey: Constants.UserDefaultsKeys.currentWater)
        
    }
}

// MARK: - TextField delegate
extension MainViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        drinkWater()
        return true
    }

}
