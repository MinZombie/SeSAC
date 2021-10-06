import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var searchContainer: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tagFirstButton: UIButton!
    @IBOutlet weak var tagSecondButton: UIButton!
    @IBOutlet weak var tagThirdButton: UIButton!
    @IBOutlet weak var tagFourthButton: UIButton!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBAction func didTapGesture(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func didTapSearchButton(_ sender: UIButton) {
        searchWord(with: [tagFirstButton, tagSecondButton, tagThirdButton, tagFourthButton])
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        
        setUpView()
        setUpTags(with: [tagFirstButton, tagSecondButton, tagThirdButton, tagFourthButton])
        
        
    }

    // MARK: - Private
    private func setUpView() {
        searchContainer.layer.borderWidth = 2
        
        textField.borderStyle = .none
        
        searchButton.backgroundColor = .black
        searchButton.tintColor = .white
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        
        resultLabel.textAlignment = .center
        resultLabel.font = .systemFont(ofSize: 21, weight: .medium)
        resultLabel.adjustsFontSizeToFitWidth = true
        
    }
    
    private func setUpTags(with tags: [UIButton]) {
        
        for tag in tags {
            tag.layer.borderWidth = 1.2
            tag.layer.cornerRadius = 8
            tag.setTitleColor(.black, for: .normal)
            tag.setTitle(words.randomElement()?.key, for: .normal)
            tag.contentEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
            
            tag.addTarget(self, action: #selector(didTaptag(_:)), for: .touchUpInside)
            
        }
        
    }
    
    private func searchWord(with tags: [UIButton]) {
        guard let text = textField.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let trimmedText = text.trimmingCharacters(in: .whitespaces)
        
        if words.keys.contains(trimmedText) {

            resultLabel.text = words[trimmedText]
            // 검색 후 텍스트필드 문자열 지우기
            textField.text = ""

            // 검색 후 키보드 내리기
            textField.resignFirstResponder()
        } else {
            // Alert
        }
        
        for tag in tags {
            tag.setTitle(words.randomElement()?.key, for: .normal)
        }
    }
    
    @objc func didTaptag(_ sender: UIButton) {
        guard let text = sender.titleLabel?.text else { return }
        resultLabel.text = words[text]
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchWord(with: [tagFirstButton, tagSecondButton, tagThirdButton, tagFourthButton])
        return true
    }
}

