//
//  ProfileViewController.swift
//  DrinkWater
//
//  Created by 민선기 on 2021/10/08.
//

import UIKit



class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet var saveBarButton: UIBarButtonItem!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    
    @IBAction func didTapGesture(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    @objc func didTapSaveBarButton(_ sender: UIBarButtonItem) {
        save()

    }
    
    // MARK: - Private
    private func setUpView() {
        view.backgroundColor = .systemGreen
    
        navigationController?.navigationBar.tintColor = .white
        
        saveBarButton.target = self
        saveBarButton.action = #selector(didTapSaveBarButton(_:))
        saveBarButton.title = "저장"
        
        profileImageView.image = UIImage(named: "1-2")
        
        nicknameLabel.text = Constants.ProfileViewControllerText.nicknameText
        nicknameLabel.textColor = .white
        
        heightLabel.text = Constants.ProfileViewControllerText.heightText
        heightLabel.textColor = .white
        
        weightLabel.text = Constants.ProfileViewControllerText.weightText
        weightLabel.textColor = .white
        
        
        setUpTextField(textField: nicknameTextField, returnType: .next)
        setUpTextField(textField: heightTextField, keyboard: .numberPad)
        setUpTextField(textField: weightTextField, keyboard: .numberPad)
    }
                              
    
    private func setUpTextField(textField: UITextField, returnType: UIReturnKeyType? = nil, keyboard: UIKeyboardType? = nil) {
        
        func textFieldUnderline(textField: UITextField) {
            let layer = CALayer()
            let position = textField.frame.origin
            let width = textField.frame.width

            layer.frame = .init(x: position.x, y: position.y + 4, width: width, height: 3)
            layer.backgroundColor = UIColor.white.cgColor
            textField.layer.addSublayer(layer)
        }
        
        textField.delegate = self
        textField.borderStyle = .none
        textFieldUnderline(textField: textField)
        textField.textColor = .label
        textField.font = .systemFont(ofSize: 23)
        textField.returnKeyType = returnType ?? .default
        textField.keyboardType = keyboard ?? .default

    }
    
    private func save() {
        guard let nickname = nicknameTextField.text, let height = heightTextField.text, let weight = weightTextField.text,
              !nickname.trimmingCharacters(in: .whitespaces).isEmpty, !height.trimmingCharacters(in: .whitespaces).isEmpty,
              !weight.trimmingCharacters(in: .whitespaces).isEmpty
        else {
            alert(title: "모든 정보를 입력해주세요.", message: nil, buttonTitle: "확인")
            return
        }
        
        if nickname.count > 10 {
            alert(title: "닉네임은 10자 이하로 정해주세요.", message: nil, buttonTitle: "확인")
        }
        
        if let encoded = try? JSONEncoder().encode(User(nickname: nickname, height: Float(height) ?? 0, weight: Float(weight) ?? 0, state: .hasInfo)) {
            UserDefaults.standard.setValue(encoded, forKey: Constants.UserDefaultsKeys.userDefault)
        }

        self.navigationController?.popViewController(animated: true)
    }
    
    private func alert (title: String, message: String?, buttonTitle: String) {
        self.view.endEditing(true)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
}

// MARK: - TextField delegate
extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // 닉네임 텍스트필드에서 next버튼 누르면 다음 텍스트필드로 이동
        if textField == nicknameTextField {
            heightTextField.becomeFirstResponder()
        }
        
        return true
    }

}
