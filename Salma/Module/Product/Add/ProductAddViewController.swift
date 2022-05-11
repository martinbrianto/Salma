//
//  ProductAddViewController.swift
//  Salma
//
//  Created by Sugiharso Wijaya on 21/04/22.
//

import UIKit

class ProductAddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Outlets
    @IBOutlet weak var productNameTextFieldView: TextFieldView!
    @IBOutlet weak var productPriceTextFieldView: PriceTextFieldView!
    @IBOutlet weak var productWeightTextFieldView: TextFieldView!
    @IBOutlet weak var imagePreviewView: UIView!
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var productButton: UIButton!
    @IBOutlet weak var selectImageView: UIView!
    
    // MARK: - Variables
    private var productPageState: ProductPageState
//    var imagePickerData: Data
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPage()
        setupTextField()
        keyboardDismisser()
    }
    
    init(from productPageState: ProductPageState){
        self.productPageState = productPageState
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func imagePickerButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        imagePreview.image = image
        selectImageView.isHidden = true
        imagePreviewView.isHidden = false
        dismiss(animated: true)
    }
    
    @IBAction func productButtonAction(_ sender: Any) {
        switch productPageState {
        case .add:
            validateTextField()
        case .edit:
            validateTextField()
        case .details:
            //Delete data
            //Pop to root
            break
        }
    }
    
    @objc func changeImage (_ gesture: UITapGestureRecognizer){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
}

//handle keyboard
private extension ProductAddViewController {
    private func keyboardDismisser(){
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
}

extension ProductAddViewController: UITextFieldDelegate {
    private func setupPage(){
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeImage(_:)))
        gestureRecognizer.numberOfTapsRequired = 1
        gestureRecognizer.numberOfTouchesRequired = 1
        
        imagePreview.addGestureRecognizer(gestureRecognizer)
        imagePreview.isUserInteractionEnabled = true
        
        switch productPageState {
        case .add:
            title = "Add Product"
            productButton.backgroundColor = UIColor.blue
            productButton.setTitleColor(UIColor.white, for: .normal)
            productButton.isHidden = false
            productButton.titleLabel?.text = "Save"
            imagePreviewView.isHidden = true
            selectImageView.isHidden = false
        case .edit:
            title = "Edit Product"
            productButton.isHidden = true
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Save", style: .done, target: self, action: #selector(navbarRightActionButtonSave(sender:)))
            selectImageView.isHidden = true
            imagePreviewView.isHidden = false
        case .details:
            title = "Product Details"
            productButton.backgroundColor = UIColor.white
            productButton.setTitleColor(UIColor.red, for: .normal)
            productButton.isHidden = false
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Edit", style: .done, target: self, action: #selector(navbarRightActionButtonEdit(sender:)))
            selectImageView.isHidden = true
            imagePreviewView.isHidden = false
        }
    }
    
    private func setupTextField(){
        productNameTextFieldView.textfieldView.delegate = self
        productPriceTextFieldView.textfieldView.delegate = self
        productPriceTextFieldView.textfieldView.keyboardType = UIKeyboardType.numberPad
        productWeightTextFieldView.textfieldView.delegate = self
        productWeightTextFieldView.textfieldView.returnKeyType = .done
        productWeightTextFieldView.textfieldView.keyboardType = UIKeyboardType.numberPad
        productNameTextFieldView.textfieldData = Textfield(title: "Product Name", placeholder: "e.g. Tumblr")
        productPriceTextFieldView.textfieldData = Textfield(title: "Price", placeholder: "0")
        productWeightTextFieldView.textfieldData = Textfield(title: "Weight (g)", placeholder: "e.g. 1000")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.productNameTextFieldView.textfieldView:
            self.productPriceTextFieldView.textfieldView.becomeFirstResponder()
        case self.productPriceTextFieldView.textfieldView:
            self.productWeightTextFieldView.textfieldView.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
            print("insert done action")
        }
        return true
    }
    
    private func validateTextField(){
        var errorCount = 0
        // Validate product name
        if (productNameTextFieldView.textfieldView.text ?? "").isEmpty {
            errorCount += 1
            productNameTextFieldView.errorMessage = "Product name must be filled!"
        }else{
            productNameTextFieldView.errorMessage = nil
        }
        
        // Validate product price
        if (productPriceTextFieldView.textfieldView.text ?? "").isEmpty {
            errorCount += 1
            productPriceTextFieldView.errorMessage = "Product price must be filled!"
        }else{
            productPriceTextFieldView.errorMessage = nil
        }
        
        // Validate product weight
        if (productWeightTextFieldView.textfieldView.text ?? "").isEmpty {
            errorCount += 1
            productWeightTextFieldView.errorMessage = "Product weight must be filled!"
        }else{
            productWeightTextFieldView.errorMessage = nil
        }
        
        if errorCount == 0 {
            // Add data
            // Pop to root
        }
    }
    
    @objc func navbarRightActionButtonSave(sender: UIBarButtonItem) {
        // Save changes
        // Pop to root
    }
    
    @objc func navbarRightActionButtonEdit(sender: UIBarButtonItem) {
        // Change to .edit
    }
    
}


