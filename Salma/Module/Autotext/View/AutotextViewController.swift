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
    @IBAction func autotextAddButton(_ sender: Any) {
        let viewController = AutotextAddViewController(state: .add, viewModel: AutotextAddVCViewModel(data: nil))
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: - Variables
    private let viewModel = AutotextVCViewModel()
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
        setupPage()
        bindToViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
        super.viewWillDisappear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchAutotextList()
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - ViewModel
    private func bindToViewModel() {
        viewModel.didUpdate = { [weak self] _ in
            self?.viewModeldidUpdate()
        }
    }
    
    private func viewModeldidUpdate(){
        autotextTableView.reloadData()
    }
}

private extension AutotextViewController{
    private func setupPage(){
        autotextTableView.register(AutotextTableViewCell.nib(), forCellReuseIdentifier: AutotextTableViewCell.reuseID)
        viewModel.fetchAutotextList()
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
            return viewModel.fetchedDefaultAutotext.count
        case .custom:
            return viewModel.fetchedCustomAutotext.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch TableViewSection.getSection(indexPath.section){
            
        case .transaction:
            let cell = tableView.dequeueReusableCell(withIdentifier: AutotextTableViewCell.reuseID, for: indexPath) as! AutotextTableViewCell
            cell.title = viewModel.fetchedDefaultAutotext[indexPath.row].title
            return cell
        case .custom:
            let cell = tableView.dequeueReusableCell(withIdentifier: AutotextTableViewCell.reuseID, for: indexPath) as! AutotextTableViewCell
            cell.title = viewModel.fetchedCustomAutotext[indexPath.row].title
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch TableViewSection.getSection(indexPath.section){
        case .transaction:
            let viewModel = viewModel.autotextAddVCViewModelDefaultDetail(index: indexPath.row)
            let vc = AutotextAddViewController(state: .detailDefault, viewModel: viewModel)
            navigationController?.pushViewController(vc, animated: true)
        case .custom:
            let viewModel = viewModel.autotextAddVCViewModelCustomDetail(index: indexPath.row)
            let vc = AutotextAddViewController(state: .detailCustom, viewModel: viewModel)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
