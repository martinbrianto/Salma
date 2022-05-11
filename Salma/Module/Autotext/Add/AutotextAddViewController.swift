//
//  AutotextAddViewController.swift
//  Salma
//
//  Created by Sugiharso Wijaya on 26/04/22.
//

import UIKit

class AutotextAddViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var titleTextField: TextFieldView!
    @IBOutlet weak var autotextTitleTextField: UITextField!
    @IBOutlet weak var autotextMessageTextView: UITextView!
    
    // MARK: - Variable
    var errorCount = 0
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
    
    init(from pageState: AutotextPageState){
        self.pageState = pageState
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func addAutotextButton(_ sender: Any) {
        //add validation
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
        errorCount = 0
        if autotextTitleTextField.text == "" {
            //Change textField error isHidden to false
            titleTextField.errorMessage = "title tidak boleh kosong"
            errorCount += 1
        }
        
        if autotextMessageTextView.text == ""{
            //Change tesctView error isHidden to false
            errorCount += 1
        }
        
        if errorCount == 0 {
            //pop back
            self.navigationController?.popToRootViewController(animated: true)
        }else{
            //error notification popup
        }
    }
}

//handle keyboard
private extension AutotextAddViewController {
    private func keyboardDismisser(){
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
}

extension AutotextAddViewController: UITextFieldDelegate, UITextViewDelegate {
    private func setupPage(){
        title = "Add Autotext"
        switch pageState {
        case .add:
            title = "Add Autotext"
            //Change button to blue & text, hidden to false
        case .edit:
            title = "Autotext Details"
            //Change button hidden to true
            //Change navBar Item to Save
        case .detail:
            title = "Autotext Details"
            //Change button to red & text, hidden to false
            //Change navBar Item to Edit
            //Add function to change navBar purpose
        }
    }
    
    private func setupTextField(){
        titleTextField.textfieldView.delegate = self
        autotextMessageTextView.delegate = self
        titleTextField.textfieldData = Textfield(title: "Autotext Title", placeholder: "e.g. Product A")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField{
            case self.titleTextField.textfieldView: self.autotextMessageTextView.becomeFirstResponder()
            default:
                textField.resignFirstResponder()
                print("insert done action")
            }
        return true
        }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if autotextMessageTextView.text.isEmpty {
            
        }
    }
    
    private func textViewDisplayPlaceholder(_ isEmpty: Bool){
        if isEmpty {
            autotextTitleTextField.text = "e.g. Barang Ready Stock, Silakan di order"
        }
    }
}
