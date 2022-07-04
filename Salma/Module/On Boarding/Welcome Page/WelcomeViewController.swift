//
//  WelcomeViewController.swift
//  Salma
//
//  Created by gratianus.brianto on 04/07/22.
//

import UIKit

class WelcomeViewController: UIViewController {

    
    @IBAction func getStartedAction(_ sender: UIButton) {
        let vc = StoreProfileViewController(from: .onboarding)
        self.navigationController?.pushViewController(vc, animated: true )
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
