//
//  DetailTransactionViewModel.swift
//  Salma
//
//  Created by gratianus.brianto on 06/06/22.
//

import Foundation

class DetailTransactionViewModel {
    // MARK: - Private
    private let service: CoreDataManager
    var data: TransactionModel
    var transactionID: UUID?
    
    let customerDataTextfield: [TransactionTextfieldType] = [.customerName, .customerPhoneNumber]
    let addressTextfield: [TransactionTextfieldType] = [.addressName,.addressProvince, .addressCity,.addressDistrict,.addressPostalCode]
    let shippingTextfield: [TransactionTextfieldType] = [.shippingExpedition, .shippingPrice]
    var productTextfield: [TransactionTextfieldType] = [.addProduct, .productNote]
    let priceCell: [TransactionTextfieldType] = [.totalPrice]
    
    init(service: CoreDataManager = CoreDataManager.shared, id: UUID?){
        if let id = id {
            self.transactionID = id
            self.data = service.fetchOneTransaction(transactionID: id) ?? .initEmpty()
        } else {
            self.data = .initEmpty()
        }
        self.service = service
    }

    // MARK: - Events
    var didError: ((Error) -> Void)?
    var didSave: ((DetailTransactionViewModel?) -> Void)?
    var didDelete: ((DetailTransactionViewModel?) -> Void)?
    var didUpdate: ((DetailTransactionViewModel?) -> Void)?
    var didUpdateProduct: ((DetailTransactionViewModel?) -> Void)?
    var didSelect: ((TransactionModel) -> Void)?
    var didUpdateData: ((DetailTransactionViewModel?) -> Void)?
    var didUpdatePriceData: ((DetailTransactionViewModel?) -> Void)?
    var didUpdateTransactionStatus: ((DetailTransactionViewModel?) -> Void)?
}

extension DetailTransactionViewModel {
    func fetchTransactionData() {
        guard let transactionID = transactionID else { return }
        
        if let fetchedTransaction = service.fetchOneTransaction(transactionID: transactionID) {
            let products = service.fetchProductsOfTransaction(transactionID: transactionID)
            self.data = fetchedTransaction
            self.data.productTransactions = products
        }
        setupProductCell()
    }
    
    func setupProductCell(){
        productTextfield = [.addProduct]
        data.productTransactions?.forEach { _ in
            productTextfield.append(.productCell)
        }
        productTextfield.append(.productNote)
        didUpdate?(self)
    }
    
    func addCustomProduct(_ : ProductModel) {
        productTextfield = [.addProduct]
        data.productTransactions?.forEach { product in
            productTextfield.append( .productCell )
        }
        productTextfield.append(.productNote)
        didUpdateProduct?(self)
    }
    
    func receiveProductData(products : [ProductModel]) {
        self.data.productTransactions = products
        productTextfield = [.addProduct]
        data.productTransactions?.forEach { _ in
            productTextfield.append(.productCell)
        }
        productTextfield.append(.productNote)
        didUpdateProduct?(self)
    }
    
    func saveTransaction(){
        data.id = UUID()
        service.saveTransaction(transactionData: data)
        addTransactionProduct()
    }
    
    func addTransactionProduct(){
        guard let transactionID = data.id, let transactionProduct = data.productTransactions else { return }
        transactionProduct.forEach{ product in
            let productQuantity = product.quantity
            if let productID = product.id {
                service.addProductsToTransaction(transactionID: transactionID, productID: productID, quantity: productQuantity)
            } else {
                //custom
                service.addCustomProductsToTransaction(transactionID: transactionID, productData: product)
            }
        }
        didSave?(self)
    }
    
    func updateTransaction(data: TransactionModel, id: UUID){
        service.updateTransaction(transactionID: id, transactionData: data)
        service.removeAllProductOfTransaction(transactionID: id)
        addTransactionProduct()
        fetchTransactionData()
    }
    
    func deleteTransaction() {
        guard let transactionID = transactionID else { return }
        service.deleteTransaction(transactionID: transactionID)
        didDelete?(self)
    }
    
    func validateTransaction() -> Bool {
        if data.customerName.isEmpty {
            return false
        }
        if data.customerPhoneNumber.isEmpty {
            return false
        }
        if data.addressName.isEmpty {
            return false
        }
        if data.addressProvince.isEmpty {
            return false
        }
        if data.addressCity.isEmpty {
            return false
        }
        if data.addressDistrict.isEmpty {
            return false
        }
        if data.addressPostalCode.isEmpty {
            return false
        }
        if data.notes == nil {
            return false
        }
        if data.expedition.isEmpty {
            return false
        }
        if data.shippingPrice == 0 {
            return false
        }
        if data.productTransactions == nil {
            return false
        }
        if data.priceSubTotal == 0 {
            return false
        }
        return true
    }
    
    func countSubTotal(){
        guard let productTransaction = data.productTransactions else { return }
        data.priceSubTotal = 0
        productTransaction.forEach{
            data.priceSubTotal += $0.price
        }
        
        countTotal()
        didUpdatePriceData?(self)
    }
    
    func countTotal() {
        data.priceTotal = data.priceSubTotal + data.shippingPrice
        didUpdatePriceData?(self)
    }
    
    func productTransactionViewModel() -> ProductTransactionVCViewModel{
        let viewModel = ProductTransactionVCViewModel(products: data.productTransactions)
        return viewModel
    }
    
    func setTransactionStatus(to: Status){
        guard let id = data.id else {return}
        switch to {
        case .notPaid:
            break
        case .inProgress:
            service.addTransactionPaidDate(transactionID: id)
        case .completed:
            service.addTransactionCompleteDate(transactionID: id)
        }
        fetchTransactionData()
    }
}
