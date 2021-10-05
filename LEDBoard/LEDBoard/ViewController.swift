//
//  ViewController.swift
//  LEDBoard
//
//  Created by 민선기 on 2021/10/02.
//

import UIKit

class ViewController: UIViewController {
    
    var showBoardView = true

    @IBOutlet weak var boardView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var fontChangeButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBAction func didTapGesture(_ sender: UITapGestureRecognizer) {
        showBoardView.toggle()
        
        if !showBoardView {
            boardView.isHidden = true
            
        } else {
            boardView.isHidden = false
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        textField.delegate = self
        
        setUpView()
        
        sendButton.addTarget(self, action: #selector(didTapSendButton(_:)), for: .touchUpInside)
        fontChangeButton.addTarget(self, action: #selector(didTapFontChangeButton(_:)), for: .touchUpInside)
    }

    private func setUpView() {
        boardView.backgroundColor = .white
        boardView.layer.cornerRadius = 10
        
        textField.placeholder = "텍스트를 입력해주세요"
        
        
        sendButton.layer.cornerRadius = 6
        sendButton.layer.borderWidth = 2
        sendButton.setTitle("send", for: .normal)
        sendButton.setTitleColor(.label, for: .normal)
        sendButton.backgroundColor = .systemBackground
        
        
        fontChangeButton.layer.cornerRadius = 6
        fontChangeButton.layer.borderWidth = 2
        fontChangeButton.setTitle("Aa", for: .normal)
        fontChangeButton.setTitleColor(.systemRed, for: .normal)
        fontChangeButton.backgroundColor = .systemBackground
        
        resultLabel.font = .boldSystemFont(ofSize: 70)
        resultLabel.adjustsFontSizeToFitWidth = true
    }
    
    @objc func didTapSendButton(_ sender: UIButton) {
        guard let text = textField.text else { return }
        resultLabel.text = text
        textField.text = ""
    }
    
    @objc func didTapFontChangeButton(_ sender: UIButton) {
        let color = UIColor(red: CGFloat.random(in: 0.0...1.0), green: CGFloat.random(in: 0.0...1.0), blue: CGFloat.random(in: 0.0...1.0), alpha: 1.0)
        resultLabel.textColor = color
    }
}

extension ViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

