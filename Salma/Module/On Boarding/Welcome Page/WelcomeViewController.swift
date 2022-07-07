//
//  WelcomeViewController.swift
//  Salma
//
//  Created by gratianus.brianto on 04/07/22.
//

import UIKit

enum WelcomePageEntryPoint {
    case firstLaunch
    case notFirstLaunch
}

class WelcomeViewController: UIViewController {

    
    @IBOutlet weak var loading: UIView!
    @IBAction func getStartedAction(_ sender: UIButton) {
        
        switch entryPoint {
        case .firstLaunch:
            let vc = StoreProfileViewController(from: .onboarding)
            self.navigationController?.pushViewController(vc, animated: true )
        case .notFirstLaunch:
            let vc = EnableKeyboardViewController(from: .onboardingExistingUser)
            self.navigationController?.pushViewController(vc, animated: true )
        }
    }
    
    let entryPoint: WelcomePageEntryPoint
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    init(from: WelcomePageEntryPoint) {
        self.entryPoint = from
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
