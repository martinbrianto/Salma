//
//  ProductAddViewController.swift
//  Salma
//
//  Created by Sugiharso Wijaya on 21/04/22.
//

import UIKit

protocol ProductAddViewControllerDelegate {
    func addCustomProduct(product: ProductModel)
}

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
    private var productPageState: ProductPageState {
        didSet {
            setupPage()
        }
    }
    private let viewModel: ProductAddVCViewModel
    var delegate: ProductAddViewControllerDelegate?
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPage()
        setupTextField()
        keyboardDismisser()
    }
    
    init(from productPageState: ProductPageState, viewModel: ProductAddVCViewModel){
        self.productPageState = productPageState
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bindToViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func imagePickerButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        self.navigationController?.present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        imagePreview.image = image
        selectImageView.isHidden = true
        imagePreviewView.isHidden = false
        picker.dismiss(animated: true)
    }
    
    @IBAction func productButtonAction(_ sender: Any) {
        if validateTextField() {
            switch productPageState {
            case .add:
                let imageData = viewModel.convertToData(image: imagePreview.image)
                let productData = ProductModel(
                    image: imageData,
                    name: productNameTextFieldView.textfieldView.text ?? "",
                    price: Float(productPriceTextFieldView.textfieldView.text ?? "0") ?? 0,
                    weight: Int32(productWeightTextFieldView.textfieldView.text ?? "0") ?? 0,
                    quantity: 0
                )
                if viewModel.productList.contains(where: { $0.name.lowercased() == productData.name.lowercased() }){
                    AlertManager.shared.showAlert(controller: self, title: "Product already exist", message: "Product \(productData.name) is already exist")
                } else {
                    viewModel.saveProduct(data: productData)
                }
                
            case .addCustom:
                let imageData = viewModel.convertToData(image: imagePreview.image)
                let productData = ProductModel(
                    image: imageData,
                    name: productNameTextFieldView.textfieldView.text ?? "",
                    price: Float(productPriceTextFieldView.textfieldView.text ?? "") ?? 0,
                    weight: Int32(productWeightTextFieldView.textfieldView.text ?? "") ?? 0,
                    quantity: 0
                )
                if viewModel.productList.contains(where: { $0.name.lowercased() == productData.name.lowercased() }){
                    AlertManager.shared.showAlert(controller: self, title: "Product already exist", message: "Product \(productData.name) is already exist")
                } else {
                    delegate?.addCustomProduct(product: productData)
                }
                self.dismiss(animated: true)
                break
            case .edit:
                guard let productId = viewModel.data?.id else { return }
                let productData = ProductModel(name: productNameTextFieldView.textfieldView.text ?? "", price: Float(productPriceTextFieldView.textfieldView.text ?? "0") ?? 0, weight: Int32(productWeightTextFieldView.textfieldView.text ?? "0") ?? 0, quantity: 0)
                viewModel.updateProduct(data: productData, id: productId)
            case .details:
                AlertManager.shared.showDeleteAlertActionSheet(controller: self) { [weak self] _ in
                    guard let productId = self?.viewModel.data?.id else { return }
                    self?.viewModel.deleteProduct(id: productId)
                }
            }
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func changeImage (_ gesture: UITapGestureRecognizer){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
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
        DispatchQueue.main.async { [self] in
            let image = viewModel.getImageFromData(imageData: viewModel.data?.image)
            imagePreview.image = image ??  UIImage(named: "placeholder")
            productNameTextFieldView.textfieldView.text = viewModel.data?.name
            productPriceTextFieldView.textfieldView.text = "\(viewModel.data?.price ?? 0)"
            productWeightTextFieldView.textfieldView.text = "\(viewModel.data?.weight ?? 0)"
            
        }
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
        
        imagePreviewView.addGestureRecognizer(gestureRecognizer)
        imagePreviewView.isUserInteractionEnabled = true
        DispatchQueue.main.async { [self] in
        switch productPageState {
        case .add:
            title = "Add Product"
            productButton.isHidden = false
            imagePreviewView.isHidden = true
            selectImageView.isHidden = false
        case .addCustom:
            title = "Add Custom Product"
            productButton.isHidden = false
            imagePreviewView.isHidden = true
            selectImageView.isHidden = false
            productButton.setTitle("Add Custom Product", for: .normal)
            productButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        case .edit:
            title = "Edit Product"
            productNameTextFieldView.isEnabled = true
            productWeightTextFieldView.isEnabled = true
            productPriceTextFieldView.isEnabled = true
            productButton.isHidden = true
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Save", style: .done, target: self, action: #selector(navbarRightActionButton))
            selectImageView.isHidden = true
            imagePreviewView.isHidden = false
        case .details:
            viewModel.fetchProductData()
            title = "Product Details"
            productNameTextFieldView.isEnabled = false
            productWeightTextFieldView.isEnabled = false
            productPriceTextFieldView.isEnabled = false
            productButton.isHidden = false
            productButton.backgroundColor = .clear
            productButton.setTitle("Delete Product", for: .normal)
            productButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
            productButton.setTitleColor(UIColor.red, for: .normal)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Edit", style: .done, target: self, action: #selector(navbarRightActionButton))
            selectImageView.isHidden = true
            imagePreviewView.isHidden = true
            }
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
        default:
            textField.resignFirstResponder()
            print("insert done action")
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case self.productNameTextFieldView.textfieldView:
            self.productNameTextFieldView.errorMessage = nil
        case self.productPriceTextFieldView.textfieldView:
            self.productPriceTextFieldView.errorMessage = nil
        case self.productWeightTextFieldView.textfieldView:
            self.productWeightTextFieldView.errorMessage = nil
        default:
            break
        }
    }
    
    private func validateTextField() -> Bool {
        var errorCount = 0
        // Validate product name
        if (productNameTextFieldView.textfieldView.text ?? "").isEmpty {
            errorCount += 1
            productNameTextFieldView.errorMessage = "Product name must be filled!"
        } else {
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
        } else {
            productWeightTextFieldView.errorMessage = nil
        }
        
        if errorCount == 0 {
            return true
        }else{
            return false
        }
    }
    
     @objc private func navbarRightActionButton(sender: UIBarButtonItem) {
        switch self.productPageState {
        case .add, .addCustom:
            break
        case .edit:
            //save
            if validateTextField() {
                guard let productId = viewModel.data?.id else { return }
                let imageData = viewModel.convertToData(image: imagePreview.image)
                let productData = ProductModel(
                    image: imageData,
                    id: productId,
                    name: productNameTextFieldView.textfieldView.text ?? "",
                    price: Float(productPriceTextFieldView.textfieldView.text ?? "0") ?? 0,
                    weight: Int32(productWeightTextFieldView.textfieldView.text ?? "0") ?? 0,
                    quantity: 0
                )
                viewModel.updateProduct(data: productData, id: productId)
                productPageState = .details
            }
        case .details:
            productPageState = .edit
        }
    }
}


