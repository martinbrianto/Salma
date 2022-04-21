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
    
    // MARK: - VC LifeCycle
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
    
    @IBAction func settingButtonAction(_ sender: Any) {
        let viewController = SettingViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

private extension DashboardViewController {
    private func registerNIB(){
        transactionTableView.register(TransactionTableViewCell.nib(), forCellReuseIdentifier: TransactionTableViewCell.reuseID)
    }
}

// MARK: - Tableview
extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
