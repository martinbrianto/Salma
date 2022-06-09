//
//  DetailTransactionViewController.swift
//  Salma
//
//  Created by gratianus.brianto on 02/06/22.
//

import UIKit

class DetailTransactionViewController: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    private var pageState: TransactionPageState
    private let viewModel: DetailTransactionViewModel
    
    private enum TableViewSection: CaseIterable {
        case customerData
        case address
        case productDetails
        case shippingDetails
        case totalPrice
        case button
        
        static func numberOfSections() -> Int {
            return self.allCases.count
        }
        
        static func getSection(_ section: Int) -> TableViewSection {
            return self.allCases[section]
        }
    }

    // MARK: - VC LifeCycle
    
    init(state: TransactionPageState, viewModel: DetailTransactionViewModel){
        self.pageState = .detail
        self.viewModel =  viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPage()
    }
}

private extension DetailTransactionViewController {
    private func setupPage() {
        tableView.register(TransactionTextFieldTableViewCell.nib(), forCellReuseIdentifier: TransactionTextFieldTableViewCell.reuseID)
        tableView.register(TransactionTextfieldHeaderView.nib(), forHeaderFooterViewReuseIdentifier: TransactionTextfieldHeaderView.reuseID)
        tableView.register(TransactionButtonTableViewCell.nib(), forCellReuseIdentifier: TransactionButtonTableViewCell.reuseID)
        tableView.register(TransactionProductTableViewCell.nib(), forCellReuseIdentifier: TransactionProductTableViewCell.reuseID)
        tableView.register(TransactionPriceTableViewCell.nib(), forCellReuseIdentifier: TransactionPriceTableViewCell.reuseID)
    }
}

extension DetailTransactionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableViewSection.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TransactionTextfieldHeaderView.reuseID) as! TransactionTextfieldHeaderView
        switch TableViewSection.getSection(section) {
        case .customerData:
            header.title = "Customer Data"
            return header
        case .address:
            header.title = "Address"
            return header
        case .productDetails:
            header.title = "Product Details"
            return header
        case .shippingDetails:
            header.title = "Shipping Details"
            return header
        case .totalPrice:
            header.title = "Total Price"
            return header
        case .button:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch TableViewSection.getSection(section) {
            
        case .customerData:
            return 2
        case .address:
            return 5
        case .productDetails:
            return viewModel.productTextfield.count
        case .shippingDetails:
            return 2
        case .totalPrice:
            return viewModel.priceCell.count
        case .button:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch TableViewSection.getSection(indexPath.section) {
        case .customerData:
            let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTextFieldTableViewCell.reuseID) as! TransactionTextFieldTableViewCell
            cell.textfield.delegate = self
            cell.textfieldType = viewModel.customerDataTextfield[indexPath.row]
            cell.textfield.tag = viewModel.customerDataTextfield[indexPath.row].rawValue
            return cell
        case .address:
            let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTextFieldTableViewCell.reuseID) as! TransactionTextFieldTableViewCell
            cell.textfield.delegate = self
            cell.textfieldType = viewModel.addressTextfield[indexPath.row]
            cell.textfield.tag = viewModel.addressTextfield[indexPath.row].rawValue
            return cell
        case .productDetails:
            switch viewModel.productTextfield[indexPath.row] {
            case .productCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: TransactionProductTableViewCell.reuseID) as! TransactionProductTableViewCell
                return cell
                // choose product cell
            case viewModel.productTextfield.first:
                let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTextFieldTableViewCell.reuseID) as! TransactionTextFieldTableViewCell
                cell.textfieldType = viewModel.productTextfield.first
                return cell
                // product notes cell
            case viewModel.productTextfield.last:
                let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTextFieldTableViewCell.reuseID) as! TransactionTextFieldTableViewCell
                cell.textfieldType = viewModel.productTextfield.last
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTextFieldTableViewCell.reuseID) as! TransactionTextFieldTableViewCell

                return cell
            }
        case .shippingDetails:
            let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTextFieldTableViewCell.reuseID) as! TransactionTextFieldTableViewCell
            cell.textfield.delegate = self
            cell.textfieldType = viewModel.shippingTextfield[indexPath.row]
            cell.textfield.tag = viewModel.addressTextfield[indexPath.row].rawValue
            return cell
        case .totalPrice:
                let cell = tableView.dequeueReusableCell(withIdentifier: TransactionPriceTableViewCell.reuseID) as! TransactionPriceTableViewCell
                return cell
        case .button:
            let buttonCell = tableView.dequeueReusableCell(withIdentifier: TransactionButtonTableViewCell.reuseID) as! TransactionButtonTableViewCell
            return buttonCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch TableViewSection.getSection(indexPath.section) {
        case .productDetails:
            switch viewModel.productTextfield[indexPath.row] {
            case viewModel.productTextfield.first:
                break
            default:
                break
            }
                //let vc = ProductViewController
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch TableViewSection.getSection(indexPath.section) {
        case .productDetails:
            switch viewModel.productTextfield[indexPath.row] {
            case .productCell:
                return 48
            default:
                return 68
            }
        case .totalPrice:
            return 104
        case .button:
            return 48
        default:
            return 68
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch TableViewSection.getSection(section){
        case .button:
            return 0
        default:
            return 28
        }
    }
}

extension DetailTransactionViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            print(textField.text)
        default: break
        }
    }
}
