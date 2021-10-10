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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    private func setUpView() {
        view.backgroundColor = .systemGreen
    
        navigationController?.navigationBar.tintColor = .white
        
        nicknameTextField.delegate = self
        heightTextField.delegate = self
        weightTextField.delegate = self
        
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
        
        nicknameTextField.textColor = .label
        nicknameTextField.font = .systemFont(ofSize: 23)
        nicknameTextField.returnKeyType = .next
        
        heightTextField.textColor = .label
        heightTextField.font = .systemFont(ofSize: 23)
        heightTextField.keyboardType = .numberPad
        
        weightTextField.textColor = .label
        weightTextField.font = .systemFont(ofSize: 23)
        weightTextField.keyboardType = .numberPad
    }
                              
    @objc func didTapSaveBarButton(_ sender: UIBarButtonItem) {
        save()
        

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

extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // 닉네임 텍스트필드에서 next버튼 누르면 다음 텍스트필드로 이동
        if textField == nicknameTextField {
            heightTextField.becomeFirstResponder()
        }
        
        return true
    }

}
