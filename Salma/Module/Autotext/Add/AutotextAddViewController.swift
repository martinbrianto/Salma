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
    @IBOutlet weak var autotextGuideLabel: UIView!
    @IBOutlet weak var button: UIButton!
    @IBAction func buttonAction(_ sender: Any) {
        if validateAutotext() {
            switch pageState {
                case .add:
                let autoTextData = Autotext(title: autotextTitleTextField.textfieldView.text ?? "", messages: autotextMessageTextView.text ?? "")
                viewModel.saveAutotext(data: autoTextData)
                    break
                case .editCustom :
                guard let autotextId = viewModel.data?.id else { return }
                let autoTextData = Autotext(title: autotextTitleTextField.textfieldView.text ?? "", messages: autotextMessageTextView.text ?? "")
                viewModel.updateAutotext(pageState: self.pageState, data: autoTextData, id: autotextId)
                case .editDefault:
                guard let autotextId = viewModel.data?.id else { return }
                let autoTextData = Autotext(title: autotextTitleTextField.textfieldView.text ?? "", messages: autotextMessageTextView.text ?? "")
                viewModel.updateAutotext(pageState: self.pageState, data: autoTextData, id: autotextId)
                case .detailCustom:
                guard let autotextId = viewModel.data?.id else { return }
                viewModel.deleteAutotext(id: autotextId)
                    break
                case .detailDefault:
                    break
            
            }
        }
    }
    
    // MARK: - Variable
    private let viewModel: AutotextAddVCViewModel
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
    
    init(state pageState: AutotextPageState, viewModel: AutotextAddVCViewModel){
        self.pageState = pageState
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewModel
    private func bindToViewModel() {
        viewModel.didUpdate = { [weak self] _ in
            self?.viewModelDidUpdate()
        }
        
        viewModel.didError = { [weak self] _ in
            self?.viewModelDidError()
        }
        
        viewModel.didSave = { [weak self] _ in
            self?.viewModelDidSave()
        }
        
        viewModel.didDelete = { [weak self] _ in
            self?.viewModelDidDelete()
        }
        
        viewModel.didUpdateData = { [weak self] _ in
            self?.viewModelDidUpdateData()
        }
    }
    
    private func viewModelDidUpdate(){
        autotextTitleTextField.textfieldView.text = viewModel.data?.title
        autotextMessageTextView.text = viewModel.data?.messages
    }
    
    private func viewModelDidError(){
        //TODO: Handle error
    }
    
    private func viewModelDidUpdateData(){
        //TODO: Handle update data
    }
    
    private func viewModelDidDelete(){
        self.navigationController?.popViewController(animated: true)
    }
    
    private func viewModelDidSave(){
        self.navigationController?.popViewController(animated: true)
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
        case .editCustom:
            title = "Autotext Edit"
            button.isHidden = true
            autotextTitleTextField.isEnabled = true
            autotextMessageTextView.isEditable = true
            autotextMessageTextView.textColor = .darkText
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(navBarItemTapped))
        case .editDefault:
            title = "Autotext Edit"
            button.isHidden = true
            autotextTitleTextField.isEnabled = true
            autotextMessageTextView.isEditable = true
            autotextMessageTextView.textColor = .darkText
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(navBarItemTapped))
        case .detailCustom:
            viewModel.fetchAutotext()
            title = "Autotext Details"
            button.isHidden = false
            button.tintColor = .clear
            button.setTitle("Delete Autotext", for: .normal)
            button.setTitleColor(.red, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
            autotextTitleTextField.isEnabled = false
            autotextMessageTextView.isEditable = false
            autotextMessageTextView.textColor = UIColor(named: "textFieldDisabled")
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(navBarItemTapped))
        case .detailDefault:
            viewModel.fetchAutotext()
            title = "Autotext Details"
            autotextGuideLabel.isHidden = false
            autotextTitleTextField.isEnabled = false
            autotextMessageTextView.isEditable = false
            autotextMessageTextView.textColor = UIColor(named: "textFieldDisabled")
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(navBarItemTapped))
        }
    }
    
    @objc private func navBarItemTapped(){
        switch pageState {
        case .add:
            break
        case .editCustom:
            pageState = .detailCustom
        case .editDefault:
            pageState = .detailDefault
        case .detailCustom:
            pageState = .editCustom
        case .detailDefault:
            pageState = .editDefault
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
