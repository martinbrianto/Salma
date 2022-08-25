//
//  DashboardViewController.swift
//  Salma
//
//  Created by gratianus.brianto on 11/04/22.
//

import UIKit

class DashboardViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var totalPenjualanLabel: UILabel!
    @IBOutlet weak var transactionTableView: UITableView!
    @IBOutlet weak var noTransactionView: UIStackView!
    
    @IBAction func settingButtonAction(_ sender: Any) {
        let viewController = SettingViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func cekOngkirAction(_ sender: Any) {
        let vm = CekOngkirViewModel(from: viewModel.getSellerLocation(), to: nil, weight: nil)
        let vc = CekOngkirViewController(viewModel: vm, entryPoint: .dashboard)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func seeAllTransactionAction(_ sender: UIButton) {
        tabBarController?.selectedIndex = 3
    }
    
    // MARK: - Variables
    private var viewModel: DashboardVCViewModel!
    
    // MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(fetchFromBackground), name: .NSPersistentStoreRemoteChange, object: nil)
        viewModel = DashboardVCViewModel.init()
        configurePage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
        super.viewWillDisappear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        NotificationCenter.default.addObserver(self, selector: #selector(fetchFromBackground), name: UIApplication.didBecomeActiveNotification, object: nil)
        CoreDataManager.shared.persistentContainer.viewContextDidSaveExternally()
        self.fetchData()
    }
    
    
    @objc func fetchFromBackground(){
        self.fetchData()
    }
    
    // MARK: - ViewModel
    private func bindToViewModel() {
        viewModel.didUpdate = { [weak self] _ in
            self?.viewModelDidUpdate()
        }
        
        viewModel.didError = { [weak self] _ in
            self?.viewModelDidError()
        }
    }
    
    private func viewModelDidUpdate(){
        DispatchQueue.main.async {
            self.transactionTableView.reloadData()
            self.totalPenjualanLabel.text = self.viewModel.calculateTotalPenjualan().formattedToRp
            self.businessNameLabel.text = "Welcome, " + self.viewModel.getSellerProfileName()
        }
    }
    
    //TODO: error handling here
    private func viewModelDidError(){
        //handle error here
    }
    
    private func fetchData(){
        viewModel.fetchTransactionData()
    }
    
}

private extension DashboardViewController {
    private func configurePage(){
        transactionTableView.register(TransactionTableViewCell.nib(), forCellReuseIdentifier: TransactionTableViewCell.reuseID)
        self.bindToViewModel()
        businessNameLabel.text = "Welcome, " + viewModel.getSellerProfileName()
    }
}

// MARK: - Tableview
extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.sortedFetchedData.isEmpty {
            transactionTableView.isHidden = true
        } else {
            transactionTableView.isHidden = false
        }
        return viewModel.sortedFetchedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = transactionTableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.reuseID, for: indexPath) as! TransactionTableViewCell
        
        cell.transactionData = viewModel.sortedFetchedData[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = viewModel.transactionDetailVCViewModel(index: indexPath.row)
        let vc = DetailTransactionViewController(state: .detail, viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
