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
        
        heightTextField.textColor = .label
        heightTextField.font = .systemFont(ofSize: 23)
        
        weightTextField.textColor = .label
        weightTextField.font = .systemFont(ofSize: 23)
    }
                              
    @objc func didTapSaveBarButton(_ sender: UIBarButtonItem) {
        guard let nickname = nicknameTextField.text, let height = heightTextField.text, let weight = weightTextField.text else {
            return
        }
        if let encoded = try? JSONEncoder().encode(User(nickname: nickname, height: Float(height) ?? 0, weight: Float(weight) ?? 0, state: .hasInfo)) {
            UserDefaults.standard.setValue(encoded, forKey: Constants.UserDefaultsKeys.userDefault)
        }

        self.navigationController?.popViewController(animated: true)
        

    }

}
