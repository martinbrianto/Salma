//
//  ProductAddViewController.swift
//  Salma
//
//  Created by Sugiharso Wijaya on 21/04/22.
//

import UIKit

class ProductAddViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var productTitleTextField: UITextField!
    @IBOutlet weak var productWeightTextField: UITextField!
    @IBOutlet weak var productPriceTextField: UITextField!
    @IBOutlet weak var weightTextField: TextFieldView!
    
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
    }


    @IBAction func addProductButton(_ sender: Any) {
    }
    

}

extension ProductAddViewController: UITextFieldDelegate {
    private func setupTextField(){
    }
}
