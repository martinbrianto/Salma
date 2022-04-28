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
        case 0: print("ALL")
        case 1 : print("NotPaid")
        case 2 : print("InProgress")
        case 3 : print("Completed")
        default: break
        }
    }
    @IBAction func addButtonAction(_ sender: Any) {
        print("insert action button action")
    }
    
    // MARK: - Variables
    var trans1 = Transaction(
        status: .notPaid,
        customerName: "Martin",
        phoneNumber: "",
        address: "",
        province: "",
        city: "",
        district: "",
        postalCode: "",
        products: [],
        notes: nil,
        expedition: "",
        shippingPrice: 0,
        priceSubtotal: 0,
        priceTotal: 200000
    )
    var trans2 = Transaction(
        status: .inProgress,
        customerName: "ADWS",
        phoneNumber: "",
        address: "",
        province: "",
        city: "",
        district: "",
        postalCode: "",
        products: [],
        notes: nil,
        expedition: "",
        shippingPrice: 0,
        priceSubtotal: 0,
        priceTotal: 123123123
    )
    var trans3 = Transaction(
        status: .completed,
        customerName: "ASAD",
        phoneNumber: "",
        address: "",
        province: "",
        city: "",
        district: "",
        postalCode: "",
        products: [],
        notes: nil,
        expedition: "",
        shippingPrice: 0,
        priceSubtotal: 0,
        priceTotal: 123123
    )
    
    var transData: [Transaction] = []
    
    // MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNIB()
        transData = [trans1, trans2, trans3]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
        super.viewWillDisappear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

private extension TransactionViewController {
    private func registerNIB(){
        transactionTableView.register(TransactionTableViewCell.nib(), forCellReuseIdentifier: TransactionTableViewCell.reuseID)
    }
}

extension TransactionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if transData.isEmpty {
            transactionTableView.isHidden = true
        } else {
            transactionTableView.isHidden = false
        }
        return transData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = transactionTableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.reuseID, for: indexPath) as! TransactionTableViewCell
        
        cell.transactionData = transData[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
    
}
