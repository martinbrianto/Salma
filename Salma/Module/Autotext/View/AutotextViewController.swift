//
//  AutotextViewController.swift
//  Salma
//
//  Created by Gratianus Martin on 4/12/22.
//

import UIKit

class AutotextViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var autotextTableView: UITableView!
    
    // MARK: - Variables
    enum TableViewSection: CaseIterable {
        case transaction
        case custom
        
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
        registerNIB()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
        super.viewWillDisappear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        autotextTableView.reloadData()
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func autotextAddButton(_ sender: Any) {
        let viewController = AutotextAddViewController(state: .add, viewModel: AutotextAddVCViewModel(data: nil))
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

private extension AutotextViewController{
    private func registerNIB(){
        autotextTableView.register(AutotextTableViewCell.nib(), forCellReuseIdentifier: AutotextTableViewCell.reuseID)
    }
}

// MARK: - Tableview
extension AutotextViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableViewSection.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch TableViewSection.getSection(section){
        case .transaction:
            return 0
        case .custom:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch TableViewSection.getSection(indexPath.section){
            
        case .transaction:
            let cell = tableView.dequeueReusableCell(withIdentifier: AutotextTableViewCell.reuseID, for: indexPath) as! AutotextTableViewCell
            //cell.title = transactionAutotext[indexPath.row].title
            return cell
        case .custom:
            let cell = tableView.dequeueReusableCell(withIdentifier: AutotextTableViewCell.reuseID, for: indexPath) as! AutotextTableViewCell
            //cell.title = customAutotext[indexPath.row].title
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch TableViewSection.getSection(section){
        case .transaction:
            return "Transaction"
        case .custom:
            return "Custom"
        }
    }
}
