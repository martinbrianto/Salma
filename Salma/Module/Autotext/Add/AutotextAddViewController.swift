//
//  AutotextAddViewController.swift
//  Salma
//
//  Created by Sugiharso Wijaya on 26/04/22.
//

import UIKit

class AutotextAddViewController: UIViewController {
    @IBOutlet weak var autotextTitleTextField: UITextField!
    @IBOutlet weak var autotextMessageTextView: UITextView!
    
    // MARK: - Outlets
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func addAutotextButton(_ sender: Any) {
        //add validation
        
        //pop back
        self.navigationController?.popToRootViewController(animated: true)
    }
}
