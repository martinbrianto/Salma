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
    private(set) var data: ProductModel?
    let customerDataTextfield: [TransactionTextfieldType] = [.customerName, .customerPhoneNumber
    ]
    let addressTextfield: [TransactionTextfieldType] = [
        .addressName,.addressProvince, .addressCity,.addressProvince,.addressDistrict,.addressPostalCode
    ]
    let shippingTextfield: [TransactionTextfieldType] = [.shippingExpedition, .shippingPrice]
    let productTextfield: [TransactionTextfieldType] = [.product,.productCell,.productCell,.productCell, .productNote]
    let priceCell: [TransactionTextfieldType] = [.totalPrice]
    
    init(service: CoreDataManager = CoreDataManager.shared, data: ProductModel?){
        self.data = data
        self.service = service
    }

    // MARK: - Events
    var didError: ((Error) -> Void)?
    var didSave: ((DetailTransactionViewModel?) -> Void)?
    var didDelete: ((DetailTransactionViewModel?) -> Void)?
    var didUpdate: ((DetailTransactionViewModel?) -> Void)?
    var didSelect: ((TransactionModel) -> Void)?
    var didUpdateData: ((DetailTransactionViewModel?) -> Void)?
}

extension DetailTransactionViewModel {
    func fetchProductData() {
        didUpdate?(self)
    }
    
    func saveProduct(data: TransactionModel){
        service.saveTransaction(transactionData: data)
        didSave?(self)
    }
    
    func updateProduct(data: ProductModel, id: UUID){
        service.updateProduct(productID: id, newProductData: data)
        self.data = data
        didUpdateData?(self)
    }
    
    func deleteProduct(id: UUID) {
        service.deleteProduct(productID: id)
        didDelete?(self)
    }
}
