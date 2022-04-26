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
    @IBOutlet weak var productPriceTextField: UIView!
    @IBOutlet weak var productWeightTextField: UITextField!
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func addProductButton(_ sender: Any) {
        let product = Product(
            image: nil,
            title: productTitleTextField.text!,
            price: productPriceTextField.text,
            weight: productWeightTextField.text)
        
        productList.append(product)
    }
    

}
