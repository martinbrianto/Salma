//
//  DashboardViewController.swift
//  Salma
//
//  Created by gratianus.brianto on 11/04/22.
//

import UIKit

class DashboardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func settingButtonAction(_ sender: Any) {
        let viewController = SettingViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
