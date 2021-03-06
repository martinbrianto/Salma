//
//  AutotextAddViewController.swift
//  Salma
//
//  Created by Sugiharso Wijaya on 26/04/22.
//

import UIKit
import Atributika
import DropDown

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
                
                AlertManager.shared.showDeleteAlertActionSheet(controller: self) { [weak self] _ in
                    guard let autotextId = self?.viewModel.data?.id else { return }
                    self?.viewModel.deleteAutotext(id: autotextId)
                }
                
                    break
                case .detailDefault:
                    break
            
            }
        }
    }
    
    // MARK: - Variable
    private var dropDown: DropDown = {
        let view = DropDown()
        view.cellHeight = 50
        view.separatorColor = .separator
        DropDown.appearance().setupCornerRadius(14)
        view.backgroundColor = UIColor.white
        view.textColor = UIColor(named: "Main") ?? UIColor.darkText
        return view
    }()
    private var isFormatOrder: Bool = false
    private let viewModel: AutotextAddVCViewModel
    private var textViewPlaceholder: String = "e.g. Barang Ready Stock, Silakan di order"
    private var pageState: AutotextPageState{
        didSet{
            setupPage()
        }
    }
    
    // MARK: - VC Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        bindToViewModel()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPage()
        setupTextField()
        keyboardDismisser()
        if viewModel.data?.title == "Format Order" {
            self.isFormatOrder = true
        }
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
        viewModel.didUpdate = { [weak self] in
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
            self.autotextTitleTextField.textfieldView.text = self.viewModel.data?.title
            self.autotextMessageTextView.text = self.viewModel.data?.messages
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
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.title = "Add Autotext"
            switch self.pageState {
        case .add:
            self.title = "Add Autotext"
        case .editCustom:
            self.title = "Autotext Edit"
            self.button.isHidden = true
            self.autotextTitleTextField.isEnabled = true
            self.autotextMessageTextView.isEditable = true
            let attributedText = self.autotextMessageTextView.text.styleAll(Style.font(UIFont(name: "HelveticaNeue", size: 16) ?? .systemFont(ofSize: 16))).styleHashtags(Style.foregroundColor(UIColor(named: "Main") ?? UIColor.darkText)).attributedString
                self.autotextMessageTextView.attributedText = attributedText
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.navBarItemTapped))
        case .editDefault:
            self.title = "Autotext Edit"
            self.autotextTitleTextField.isEnabled = false
            self.button.isHidden = true
            self.autotextMessageTextView.isEditable = true
            let attributedText = self.autotextMessageTextView.text.styleAll(Style.font(UIFont(name: "HelveticaNeue", size: 16) ?? .systemFont(ofSize: 16))).styleHashtags(Style.foregroundColor(UIColor(named: "Main") ?? UIColor.darkText)).attributedString
            self.autotextMessageTextView.attributedText = attributedText
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.navBarItemTapped))
        case .detailCustom:
            self.viewModel.fetchAutotext()
                self.autotextMessageCharCounter.text = "\(self.autotextMessageTextView.text.count ) / 2200"
            self.title = "Autotext Details"
            self.button.isHidden = false
            self.button.backgroundColor = .clear
            self.button.setTitle("Delete Autotext", for: .normal)
            self.button.setTitleColor(.red, for: .normal)
            self.button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
            self.autotextTitleTextField.isEnabled = false
            self.autotextMessageTextView.isEditable = false
            self.autotextMessageTextView.textColor = UIColor(named: "textFieldDisabled")
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.navBarItemTapped))
        case .detailDefault:
            self.viewModel.fetchAutotext()
                self.autotextMessageCharCounter.text = "\(self.autotextMessageTextView.text.count ) / 2200"
            self.title = "Autotext Details"
            self.autotextTitleTextField.isEnabled = false
            self.autotextMessageTextView.isEditable = false
            self.autotextMessageTextView.textColor = UIColor(named: "textFieldDisabled")
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.navBarItemTapped))
            }
        }
    }
    
    @objc private func navBarItemTapped(){
        switch pageState {
        case .add:
            break
        case .editCustom:
            guard let autotextId = viewModel.data?.id else { return }
            let autoTextData = Autotext(title: autotextTitleTextField.textfieldView.text ?? "", messages: autotextMessageTextView.text ?? "", id: viewModel.data?.id)
            viewModel.updateAutotext(pageState: self.pageState, data: autoTextData, id: autotextId)
            pageState = .detailCustom
        case .editDefault:
            guard let autotextId = viewModel.data?.id else { return }
            let autoTextData = Autotext(title: autotextTitleTextField.textfieldView.text ?? "", messages: autotextMessageTextView.text ?? "", id: viewModel.data?.id)
            viewModel.updateAutotext(pageState: self.pageState, data: autoTextData, id: autotextId)
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
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case self.autotextTitleTextField.textfieldView:
            self.autotextTitleTextField.errorMessage = nil
        default:
            break
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if autotextMessageTextView.text == textViewPlaceholder {
            autotextMessageTextView.text = ""
            autotextMessageTextView.textColor = .darkText
            autotextMessageBackground.borderWidth = 0
            autotextMessageBackground.backgroundColor = UIColor(named: "PlaceholderBg")
            autotextMessageErrorLabel.isHidden = true
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
            if (characterBeforeCursor(textView) == "#") {
                if let b = textView.selectedTextRange?.start {
                    let pos: UITextPosition = b
                    let rect = textView.caretRect(for: pos)
                    let customView = UIView(frame: CGRect(x: rect.origin.x, y: rect.origin.y, width: 200, height: 0))
                                textView.addSubview(customView)
                    dropDown.anchorView = customView
                    if isFormatOrder {
                        dropDown.dataSource = formatOrderTagData
                    } else {
                        dropDown.dataSource = pageState == .editDefault ? defaultAutotextTagData : customAutotextTagData
                    }
                                // Action triggered on selection
                                dropDown.selectionAction = { (index: Int, item: String) in
                                    //remove Custom view as we no longer needed it.
                                    customView.removeFromSuperview()
                                    //Set your text accourding to selection from dropdown item.
    
                                        if let newPosition = textView.position(from: b, offset: -1) {
                                            if let range = textView.textRange(from: newPosition, to: b) {
                                                textView.replace(range, withText: "\(item) ")
                                                if let newPos = textView.position(from: b, offset: item.count) {
                                                    textView.selectedTextRange = textView.textRange(from: newPos, to: newPos)
                                                }
                                            }
                                        }
                                    
                                }
                    dropDown.show()
                }
            }
        else {
            dropDown.hide()
        }
        // coba kalo check hastagnya salah satu dari data #
        if (characterBeforeCursor(textView) == " ") {
            let attributedText = textView.text.styleAll(Style.font(UIFont(name: "HelveticaNeue", size: 16) ?? .systemFont(ofSize: 16))).styleHashtags(Style.foregroundColor(UIColor(named: "Main") ?? UIColor.darkText)).attributedString
            textView.attributedText = attributedText
        }
        
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
             return newText.count <= 2200
    }
    
    private func characterBeforeCursor(_ textView: UITextView) -> String? {
            // get the cursor position
            if let cursorRange = textView.selectedTextRange {
                // get the position one character before the cursor start position
                if let newPosition = textView.position(from: cursorRange.start, offset: -1) {
                    let range = textView.textRange(from: newPosition, to: cursorRange.start)
                    return textView.text(in: range!)
                }
            }
            return nil
        }
}
