//
//  ProductViewController.swift
//  Salma
//
//  Created by Gratianus Martin on 4/12/22.
//

import UIKit

class ProductViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

     override func viewWillDisappear(_ animated: Bool) {
         self.navigationController?.setNavigationBarHidden(false, animated: animated);
         super.viewWillDisappear(animated)
     }

     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         self.navigationController?.setNavigationBarHidden(true, animated: animated)
     }

}
