//
//  EnableKeyboardViewController.swift
//  Salma
//
//  Created by gratianus.brianto on 26/04/22.
//

import UIKit

class EnableKeyboardViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBAction func openPreferencesAction(_ sender: Any) {
        print("insert Open Preferences Action")
        if let url = URL.init(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func skipButtonAction(_ sender: Any) {
        print("insert Skip Action")
        let vc = TabBarViewController()
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }

    // MARK: - Variables
    private var entryPoint: StoreProfilePageEntryPoint
    
    // MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Enable Keyboard"
        setupPage()
    }
    
    init(from entryPoint: StoreProfilePageEntryPoint){
        self.entryPoint = entryPoint
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension EnableKeyboardViewController {
    private func setupPage(){
        switch entryPoint {
        case .onboarding:
            skipButton.isHidden = false
            titleLabel.isHidden = false
        case .settingPage:
            break
        }
    }
}
