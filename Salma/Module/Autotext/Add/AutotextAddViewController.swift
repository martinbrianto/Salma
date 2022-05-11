//
//  AutotextAddViewController.swift
//  Salma
//
//  Created by Sugiharso Wijaya on 26/04/22.
//

import UIKit

class AutotextAddViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var autotextTitleTextField: TextFieldView!
    @IBOutlet weak var autotextMessageTextView: UITextView!
    @IBOutlet weak var autotextMessageBackground: UIView!
    @IBOutlet weak var autotextMessageCharCounter: UILabel!
    @IBOutlet weak var autotextMessageErrorLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBAction func buttonAction(_ sender: Any) {
        if validateAutotext() {
            switch pageState {
                case .add:
                
                    break
                case .edit:
                    //Button
                    break
                case .detail:
                    //Button
                    //delete autotext
                    break
            }
        }
    }
    
    // MARK: - Variable
    private var textViewPlaceholder: String = "e.g. Barang Ready Stock, Silakan di order"
    private var pageState: AutotextPageState{
        didSet{
            setupPage()
        }
    }
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPage()
        setupTextField()
        keyboardDismisser()
    }
    
    init(state pageState: AutotextPageState){
        self.pageState = pageState
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}

private extension AutotextAddViewController {
    
    private func validateAutotext() -> Bool {
        var errorCounter = 0
        if (autotextTitleTextField.textfieldView.text ?? "" ).isEmpty {
            autotextTitleTextField.errorMessage = "\(autotextTitleTextField.titleLabel.text ?? "") cannot be empty"
            errorCounter += 1
        } else {
            autotextTitleTextField.errorMessage = nil
        }
        
        if autotextMessageTextView.text == textViewPlaceholder {
            autotextMessageBackground.borderWidth = 1
            autotextMessageBackground.borderColor = UIColor(named: "Red")
            autotextMessageBackground.backgroundColor = UIColor(named: "Error50")
            autotextMessageErrorLabel.text = "Messages cannot be empty"
            autotextMessageErrorLabel.isHidden = false
        } else {
            autotextMessageBackground.borderWidth = 0
            autotextMessageBackground.backgroundColor = UIColor(named: "PlaceholderBg")
            autotextMessageErrorLabel.isHidden = true
        }
        return errorCounter == 0 ? true : false
    }
    
    private func setupPage(){
        title = "Add Autotext"
        switch pageState {
        case .add:
            title = "Add Autotext"
            button.tintColor = .systemBlue
        case .edit:
            title = "Autotext Edit"
            button.isHidden = true
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(navBarItemTapped))
        case .detail:
            title = "Autotext Details"
            button.isHidden = false
            button.tintColor = .clear
            button.setTitle("Delete Autotext", for: .normal)
            button.setTitleColor(.red, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(navBarItemTapped))
        }
    }
    
    @objc private func navBarItemTapped(){
        switch pageState {
        case .add:
            break
        case .edit:
            pageState = .detail
        case .detail:
            pageState = .edit
        }
    }
}

extension AutotextAddViewController: UITextFieldDelegate, UITextViewDelegate {
    
    private func keyboardDismisser(){
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    private func setupTextField(){
        autotextTitleTextField.textfieldView.delegate = self
        autotextMessageTextView.delegate = self
        autotextTitleTextField.textfieldData = Textfield(title: "Autotext Title", placeholder: "e.g. Ready Stock")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField{
            case self.autotextTitleTextField.textfieldView: self.autotextMessageTextView.becomeFirstResponder()
            default:
                textField.resignFirstResponder()
            }
        return true
        }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if autotextMessageTextView.text == textViewPlaceholder {
            autotextMessageTextView.text = ""
            autotextMessageTextView.textColor = .darkText
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if autotextMessageTextView.text.isEmpty {
            autotextMessageTextView.text = textViewPlaceholder
            autotextMessageTextView.textColor = .placeholderText
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        autotextMessageCharCounter.text = "\(autotextMessageTextView.text.count) / 2200"
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
             return newText.count <= 2200
    }
}
