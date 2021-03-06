//
//  TransactionViewController.swift
//  Salma
//
//  Created by Gratianus Martin on 4/12/22.
//

import UIKit

class TransactionViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var noTransactionView: UIStackView!
    @IBOutlet weak var transactionTableView: UITableView!
    @IBAction func segmentedControlDidChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("ALL")
            viewModel.filterToAll()
        case 1 :
            print("NotPaid")
            viewModel.filterToNotPaid()
        case 2 :
            print("InProgress")
            viewModel.filterToInProgress()
        case 3 :
            print("Completed")
            viewModel.filterToCompleted()
        default: break
        }
    }
    @IBAction func addButtonAction(_ sender: Any) {
        let vc = DetailTransactionViewController(state: .add, viewModel: DetailTransactionViewModel(id: nil))
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func deepLinkAddTrans(){
        let vc = DetailTransactionViewController(state: .add, viewModel: DetailTransactionViewModel(id: nil))
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Variables
    var transData: [TransactionModel] = []
    var viewModel: TransactionViewModel = TransactionViewModel()
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(fetchFromBackground), name: .NSPersistentStoreRemoteChange, object: nil)
        registerNIB()
        bindToViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        NotificationCenter.default.addObserver(self, selector: #selector(fetchFromBackground), name: UIApplication.didBecomeActiveNotification, object: nil)
        viewModel.fetchData()
    }
    
    @objc func fetchFromBackground(){
        viewModel.fetchData()
    }
    
    private func bindToViewModel(){
        viewModel.didUpdate = { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.transactionTableView.reloadData()
            }
        }
    }
}

private extension TransactionViewController {
    private func registerNIB(){
        transactionTableView.register(TransactionTableViewCell.nib(), forCellReuseIdentifier: TransactionTableViewCell.reuseID)
    }
}

extension TransactionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.displayedData.isEmpty {
            transactionTableView.isHidden = true
        } else {
            transactionTableView.isHidden = false
        }
        return viewModel.displayedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = transactionTableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.reuseID, for: indexPath) as! TransactionTableViewCell
        
        cell.transactionData = viewModel.displayedData[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = viewModel.transactionDetailVCViewModel(index: indexPath.row)
        let vc = DetailTransactionViewController(state: .detail, viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
    
}
