//
//  StoreProfileViewController.swift
//  Salma
//
//  Created by gratianus.brianto on 25/04/22.
//

import UIKit

class StoreProfileViewController: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UIView!
    @IBOutlet weak var storeNameTextField: TextFieldView!
    @IBOutlet weak var storeURLTextField: TextFieldView!
    @IBOutlet weak var storeLocationTextField: TextFieldView!
    @IBOutlet weak var phoneNumberTextField: TextFieldView!
    @IBOutlet weak var nextButton: UIButton!
    @IBAction func nextButtonAction(_ sender: Any) {
        print("insert done action")
    }
    
    // MARK: - Variable
    private var entryPoint: StoreProfilePageEntryPoint
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPage()
        setupTextField()
        keyboardDismisser()
    }
    
    init(from entryPoint: StoreProfilePageEntryPoint){
        self.entryPoint = entryPoint
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//handle keyboard
private extension StoreProfileViewController {
    private func keyboardDismisser(){
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
}

extension StoreProfileViewController: UITextFieldDelegate {
    private func setupPage(){
        title = "Store Profile"
        switch entryPoint {
        case .onboarding:
            nextButton.isHidden = false
            titleLabel.isHidden = false
        case .dashboard: break
        }
    }
    
    private func setupTextField(){
        storeNameTextField.textfieldView.delegate = self
        storeURLTextField.textfieldView.delegate = self
        storeLocationTextField.textfieldView.delegate = self
        phoneNumberTextField.textfieldView.delegate = self
        phoneNumberTextField.textfieldView.returnKeyType = .done
        storeNameTextField.textfieldData = Textfield(title: "Store Name", placeholder: "e.g. Store A")
        storeURLTextField.textfieldData = Textfield(title: "Store URL", placeholder: "https://")
        storeLocationTextField.textfieldData = Textfield(title: "Store Location", placeholder: "Store Address")
        phoneNumberTextField.textfieldData = Textfield(title: "Phone Number", placeholder: "+62")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.storeNameTextField.textfieldView:
            self.storeURLTextField.textfieldView.becomeFirstResponder()
        case self.storeURLTextField.textfieldView:
            self.storeLocationTextField.textfieldView.becomeFirstResponder()
        case self.storeLocationTextField.textfieldView:
            self.phoneNumberTextField.textfieldView.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
            print("insert done action")
        }
        return true
    }
}
