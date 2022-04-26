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
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func addProductButton(_ sender: Any) {
        let product = Product(
            image: nil,
            title: "boleh",
            price: 2000,
            weight: 10000
        )
        productList.append(product)
    }
    

}
