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
    private(set) var data: TransactionModel
    
    let customerDataTextfield: [TransactionTextfieldType] = [.customerName, .customerPhoneNumber]
    let addressTextfield: [TransactionTextfieldType] = [.addressName,.addressProvince, .addressCity,.addressProvince,.addressDistrict,.addressPostalCode]
    let shippingTextfield: [TransactionTextfieldType] = [.shippingExpedition, .shippingPrice]
    var productTextfield: [TransactionTextfieldType] = [.addProduct, .productNote]
    let priceCell: [TransactionTextfieldType] = [.totalPrice]
    
    init(service: CoreDataManager = CoreDataManager.shared, data: TransactionModel?){
        if let data = data {
            self.data = data
        } else {
            self.data = .initEmpty()
        }
        let a: [ProductModel] = [ProductModel(name: "Product 1", price: 1, weight: 1, quantity: 1, isActive: nil)]
        self.data.productTransactions = a
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
}

extension DetailTransactionViewModel {
    func fetchTransactionData() {
        productTextfield = [.addProduct]
        data.productTransactions?.forEach { _ in
            productTextfield.append(.productCell)
        }
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
    
    func saveProduct(data: TransactionModel){
        service.saveTransaction(transactionData: data)
        didSave?(self)
    }
    
    func updateProduct(data: TransactionModel, id: UUID){
        //service.updateProduct(productID: id, newProductData: data)
        self.data = data
        didUpdateData?(self)
    }
    
    func deleteProduct(id: UUID) {
        service.deleteProduct(productID: id)
        didDelete?(self)
    }
    
    func productTransactionViewModel() -> ProductTransactionVCViewModel{
        let viewModel = ProductTransactionVCViewModel(products: data.productTransactions)
        return viewModel
    }
}
