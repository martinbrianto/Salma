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
        //setupFirstTimeAutotext()
        UserDefaults.standard.set(true, forKey: "didFirstLaunch")
        NSUbiquitousKeyValueStore().set(true, forKey: "didFirstLaunch")
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }

    // MARK: - Variables
    private var entryPoint: StoreProfilePageEntryPoint
    private let fetchingVC = FetchingDataViewController()
    
    // MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Enable Keyboard"
        NotificationCenter.default.addObserver(self, selector: #selector(fetchFromBackground), name: .NSPersistentStoreRemoteChange, object: nil)
        CoreDataManager.shared.persistentContainer.loadPersistentStores { _, _ in
            
        }
        setupPage()
    }
    
    @objc func fetchFromBackground(){
        if let _ = CoreDataManager.shared.fetchStoreProfile() {
            DispatchQueue.main.async {
            self.fetchingVC.dismiss(animated: true)
            }
        }
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
            titleLabel.isHidden = true
        case .settingPage:
            break
        case .onboardingExistingUser:
            skipButton.isHidden = false
            titleLabel.isHidden = true
            fetchingVC.modalPresentationStyle = .overCurrentContext
            fetchingVC.modalTransitionStyle = .crossDissolve
            fetchingVC.hidesBottomBarWhenPushed = true
            self.present(fetchingVC, animated: true)
        }
    }
    
    
}
