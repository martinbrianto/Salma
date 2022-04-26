//
//  SettingViewController.swift
//  Salma
//
//  Created by gratianus.brianto on 20/04/22.
//

import UIKit

class SettingViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Variables
    
    enum TableViewSection: CaseIterable {
        case profile
        case transaction
        
        static func numberOfSections() -> Int {
            return self.allCases.count
        }
        
        static func getSection(_ section: Int) -> TableViewSection {
            return self.allCases[section]
        }
    }
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        registerNIB()
        tableView.contentInsetAdjustmentBehavior = .always
    }
}

private extension SettingViewController {
    private func setVersionLabel(){
        versionLabel.text = "Salma - App Version \(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String)"
    }
    
    private func registerNIB(){
        tableView.register(SettingTableViewCell.nib(), forCellReuseIdentifier: SettingTableViewCell.reuseID)
    }
}

extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch TableViewSection.getSection(section) {
        case .profile:
            return 1
        case .transaction:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch TableViewSection.getSection(indexPath.section) {
            
        case .profile:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.reuseID, for: indexPath) as! SettingTableViewCell
            cell.title = "Store Profile"
            return cell
        case .transaction:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.reuseID, for: indexPath) as! SettingTableViewCell
            cell.title = "Enable Keyboard"
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableViewSection.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch TableViewSection.getSection(section) {
            
        case .profile:
            return "Profile"
        case .transaction:
            return "Transaction"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch TableViewSection.getSection(indexPath.section){
        case .profile:
            print("Go to profile page")
            let vc = StoreProfileViewController(from: .onboarding)
            self.navigationController?.pushViewController(vc, animated: true)
        case .transaction:
            print("Go to enable keyboard")
        }
    }
    
}
