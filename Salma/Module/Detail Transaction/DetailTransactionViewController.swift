//
//  DetailTransactionViewController.swift
//  Salma
//
//  Created by gratianus.brianto on 02/06/22.
//

import UIKit

protocol DetailTransactionViewControllerDelegate: DetailTransactionViewController {
    func updateProduct()
}

class DetailTransactionViewController: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    private var pageState: TransactionPageState {
        didSet {
            setupPage()
        }
    }
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
        self.pageState = state
        self.viewModel =  viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPage()
        registerNIB()
        bindToViewModel()
        keyboardDismisser()
        viewModel.fetchTransactionData()
    }
}

private extension DetailTransactionViewController {
    private func setupPage() {
        DispatchQueue.main.async { [self] in
        switch pageState {
        case .add:
            title = "Add New Transaction"
            break
        case .edit:
            title = "Edit Transaction"
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Save", style: .done, target: self, action: #selector(navbarRightActionButton))
        case .detail:
            title = "Transaction Details"
            if !(viewModel.data.status == .completed) {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Edit", style: .done, target: self, action: #selector(navbarRightActionButton))
                }
            }
        }
    }
    
    @objc private func navbarRightActionButton(sender: UIBarButtonItem) {
       switch self.pageState {
       case .add:
           title = "Add Transaction"
           break
       case .edit:
           //save
           if viewModel.validateTransaction() {
               guard let transactionID = viewModel.data.id else { return }
               viewModel.updateTransaction(data: viewModel.data, id: transactionID)
               pageState = .detail
               tableView.reloadData()
           } else {
               print("update failed")
           }
       case .detail:
           pageState = .edit
           tableView.reloadData()
       }
   }
    
    private func keyboardDismisser(){
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
    }
}

extension DetailTransactionViewController: ProductTransactionViewControllerDelegate, CekOngkirViewControllerDelegate {
    func fetchShippingRate(_ data: Pricing) {
        viewModel.receiveShippingRate(shipping: data)
    }
    
    
    func updateProductData(products: [ProductModel]) {
        viewModel.receiveProductData(products: products)
        
    }
    
    private func bindToViewModel() {
        viewModel.didUpdateProduct = { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadSections(IndexSet(integersIn: 2...2), with: .automatic)
            self.viewModel.countSubTotal()
        }
        
        viewModel.didUpdatePriceData = { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadSections(IndexSet(integersIn: 4...4), with: .none)
        }
        
        viewModel.didUpdateShippingRate = { [weak self] _ in
            guard let self = self else { return }
            let expeditionCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 3)) as! TransactionTextFieldTableViewCell
            expeditionCell.textfield.text = self.viewModel.data.expedition
            let shippingPricecell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 3)) as! TransactionTextFieldTableViewCell
            shippingPricecell.textfield.text = "\(self.viewModel.data.shippingPrice)"
            self.viewModel.countTotal()
        }
        
        viewModel.didUpdate = { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
        
        viewModel.didDelete  = { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }

    }
    
    private func registerNIB(){
        tableView.register(TransactionTextFieldTableViewCell.nib(), forCellReuseIdentifier: TransactionTextFieldTableViewCell.reuseID)
        tableView.register(TransactionTextfieldHeaderView.nib(), forHeaderFooterViewReuseIdentifier: TransactionTextfieldHeaderView.reuseID)
        tableView.register(TransactionButtonTableViewCell.nib(), forCellReuseIdentifier: TransactionButtonTableViewCell.reuseID)
        tableView.register(TransactionProductTableViewCell.nib(), forCellReuseIdentifier: TransactionProductTableViewCell.reuseID)
        tableView.register(TransactionPriceTableViewCell.nib(), forCellReuseIdentifier: TransactionPriceTableViewCell.reuseID)
    }
    
    @objc func didTapCekOngkirButton(sender: UIButton) {
        let cekOngkirViewModel = viewModel.cekOngkirViewModel()
        let vc = CekOngkirViewController(viewModel: cekOngkirViewModel, entryPoint: .transaction)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapCellButton(sender: UIButton) {
        
        switch pageState {
            
        case .add:
            if viewModel.validateTransaction() {
                viewModel.saveTransaction()
                navigationController?.popToRootViewController(animated: true)
            } else {
                AlertManager.shared.showAlert(controller: self, title: "Data Incomplete", message: "Some fields are empty")
            }
        case .edit:
            AlertManager.shared.showDeleteAlertActionSheet(controller: self) { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.deleteTransaction()
            }
            break
        case .detail:
            switch viewModel.data.status {
            case .notPaid:
                AlertManager.shared.showConfirmationAlertActionSheet(controller: self, message: "Are you sure this transaction is paid?") { [weak self] _ in
                    guard let self = self else { return }
                    self.viewModel.setTransactionStatus(to: .inProgress)
                }
            case .inProgress:
                AlertManager.shared.showConfirmationAlertActionSheet(controller: self, message: "Are you sure complete this transaction?") { [weak self] _ in
                    guard let self = self else { return }
                    self.viewModel.setTransactionStatus(to: .completed)
                }
            case .completed:
                break
            }
        }
        
    }
    
    
}

// MARK: Tableview func
extension DetailTransactionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableViewSection.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TransactionTextfieldHeaderView.reuseID) as! TransactionTextfieldHeaderView
        switch TableViewSection.getSection(section) {
        case .customerData:
            header.headerType = .customerData
            return header
        case .address:
            header.headerType = .address
            return header
        case .productDetails:
            header.headerType = .productDetails
            return header
        case .shippingDetails:
            header.headerType = .shippingDetails
            header.headerButton.addTarget(self, action: #selector(didTapCekOngkirButton(sender:)), for: .touchUpInside)
            return header
        case .totalPrice:
            header.headerType = .totalPrice
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
            cell.pageState = self.pageState
            cell.textfield.tag = viewModel.customerDataTextfield[indexPath.row].rawValue
            switch viewModel.customerDataTextfield[indexPath.row] {
            case .customerName:
                cell.textFieldInput = viewModel.data.customerName
            case .customerPhoneNumber:
                cell.textFieldInput = viewModel.data.customerPhoneNumber
            default:
                break
            }
            cell.textfieldType = viewModel.customerDataTextfield[indexPath.row]
            return cell
        case .address:
            let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTextFieldTableViewCell.reuseID) as! TransactionTextFieldTableViewCell
            cell.textfield.delegate = self
            cell.pageState = self.pageState
            cell.textfield.tag = viewModel.addressTextfield[indexPath.row].rawValue
            switch viewModel.addressTextfield[indexPath.row] {
            case .addressName:
                cell.textFieldInput = viewModel.data.addressName
            case .addressProvince:
                cell.textFieldInput = viewModel.data.addressProvince
            case .addressCity:
                cell.textFieldInput = viewModel.data.addressCity
            case .addressDistrict:
                cell.textFieldInput = viewModel.data.addressDistrict
            case .addressPostalCode:
                cell.textFieldInput = viewModel.data.addressPostalCode
            default: break
            }
            cell.textfieldType = viewModel.addressTextfield[indexPath.row]
            return cell
        case .productDetails:
            switch viewModel.productTextfield[indexPath.row] {
            case .productCell:
                let cell = tableView.dequeueReusableCell(withIdentifier: TransactionProductTableViewCell.reuseID) as! TransactionProductTableViewCell
                cell.productModel = viewModel.data.productTransactions?[indexPath.row - 1]
                return cell
                // choose product cell
            case viewModel.productTextfield.first:
                let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTextFieldTableViewCell.reuseID) as! TransactionTextFieldTableViewCell
                cell.pageState = self.pageState
                if let productCount = viewModel.data.productTransactions?.count {
                    if productCount == 0 {
                        cell.textFieldInput = ""
                    } else {
                        cell.textFieldInput = "\(productCount) Product(s) Chosen"
                    }
                }
                cell.textfieldType = viewModel.productTextfield.first
                return cell
                // product notes cell
            case viewModel.productTextfield.last:
                let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTextFieldTableViewCell.reuseID) as! TransactionTextFieldTableViewCell
                cell.textfield.delegate = self
                cell.textfield.tag = viewModel.productTextfield.last?.rawValue ?? 8
                cell.pageState = self.pageState
                cell.textFieldInput = viewModel.data.notes
                cell.textfieldType = viewModel.productTextfield.last
                return cell
            default:
                return UITableViewCell()
            }
        case .shippingDetails:
            let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTextFieldTableViewCell.reuseID) as! TransactionTextFieldTableViewCell
            cell.textfield.delegate = self
            cell.pageState = self.pageState
            cell.textfield.tag = viewModel.shippingTextfield[indexPath.row].rawValue
            switch viewModel.shippingTextfield[indexPath.row] {
            case .shippingExpedition:
                cell.textFieldInput = viewModel.data.expedition
            case .shippingPrice:
                let input = viewModel.data.shippingPrice == 0 ? "" : "\(viewModel.data.shippingPrice)"
                cell.textFieldInput = input
            default: break
            }
            cell.textfieldType = viewModel.shippingTextfield[indexPath.row]
        
            return cell
        case .totalPrice:
                let cell = tableView.dequeueReusableCell(withIdentifier: TransactionPriceTableViewCell.reuseID) as! TransactionPriceTableViewCell
            cell.transactionPriceData = viewModel.data
                return cell
        case .button:
            let buttonCell = tableView.dequeueReusableCell(withIdentifier: TransactionButtonTableViewCell.reuseID) as! TransactionButtonTableViewCell
            buttonCell.state = TransactionButton(pageState: self.pageState, transactionStatus: viewModel.data.status)
            buttonCell.button.addTarget(self, action: #selector(didTapCellButton(sender:)), for: .touchUpInside)
            return buttonCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch TableViewSection.getSection(indexPath.section) {
        case .productDetails:
            switch viewModel.productTextfield[indexPath.row] {
            case viewModel.productTextfield.first:
                let viewModel = viewModel.productTransactionViewModel()
                let vc = ProductTransactionViewController(viewModel: viewModel)
                vc.delegate = self
                if pageState == .detail {
                    break
                } else {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            default:
                break
            }
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
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.addTarget(self, action: #selector(valueChanged), for: .editingChanged)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case TransactionTextfieldType.customerName.rawValue:
            let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! TransactionTextFieldTableViewCell
            cell.textfield.becomeFirstResponder()
        case TransactionTextfieldType.customerPhoneNumber.rawValue:
            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! TransactionTextFieldTableViewCell
            cell.textfield.becomeFirstResponder()
        case TransactionTextfieldType.addressName.rawValue:
            let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as! TransactionTextFieldTableViewCell
            cell.textfield.becomeFirstResponder()
        case TransactionTextfieldType.addressProvince.rawValue:
            let cell = tableView.cellForRow(at: IndexPath(row: 2, section: 1)) as! TransactionTextFieldTableViewCell
            cell.textfield.becomeFirstResponder()
        case TransactionTextfieldType.addressCity.rawValue:
            let cell = tableView.cellForRow(at: IndexPath(row: 3, section: 1)) as! TransactionTextFieldTableViewCell
            cell.textfield.becomeFirstResponder()
        case TransactionTextfieldType.addressDistrict.rawValue:
            let cell = tableView.cellForRow(at: IndexPath(row: 4, section: 1)) as! TransactionTextFieldTableViewCell
            cell.textfield.becomeFirstResponder()
        case TransactionTextfieldType.addressPostalCode.rawValue:
            let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 2)) as! TransactionTextFieldTableViewCell
            cell.textfield.becomeFirstResponder()
        case TransactionTextfieldType.productNote.rawValue:
            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 3)) as! TransactionTextFieldTableViewCell
            cell.textfield.becomeFirstResponder()
        case TransactionTextfieldType.shippingExpedition.rawValue:
            let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 3)) as! TransactionTextFieldTableViewCell
            cell.textfield.becomeFirstResponder()
        case TransactionTextfieldType.shippingPrice.rawValue:
            break
        default: break
        }
        return true
    }
    
    @objc private func valueChanged(_ textField: UITextField) {
        switch textField.tag {
        case TransactionTextfieldType.customerName.rawValue:
            viewModel.data.customerName = textField.text ?? ""
        case TransactionTextfieldType.customerPhoneNumber.rawValue:
            viewModel.data.customerPhoneNumber = textField.text ?? ""
        case TransactionTextfieldType.addressName.rawValue:
            viewModel.data.addressName = textField.text ?? ""
        case TransactionTextfieldType.addressProvince.rawValue:
            viewModel.data.addressProvince = textField.text ?? ""
        case TransactionTextfieldType.addressCity.rawValue:
            viewModel.data.addressCity = textField.text ?? ""
        case TransactionTextfieldType.addressDistrict.rawValue:
            viewModel.data.addressDistrict = textField.text ?? ""
        case TransactionTextfieldType.addressPostalCode.rawValue:
            viewModel.data.addressPostalCode = textField.text ?? ""
        case TransactionTextfieldType.productNote.rawValue:
            viewModel.data.notes = textField.text ?? ""
        case TransactionTextfieldType.shippingExpedition.rawValue:
            viewModel.data.expedition = textField.text ?? ""
        case TransactionTextfieldType.shippingPrice.rawValue:
            viewModel.data.shippingPrice = Float(textField.text ?? "0") ?? 0
            viewModel.countTotal()
        default: break
        }
    }
}
