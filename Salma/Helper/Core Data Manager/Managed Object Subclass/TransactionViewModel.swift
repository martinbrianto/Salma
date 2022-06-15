//
//  TransactionViewModel.swift
//  Salma
//
//  Created by gratianus.brianto on 11/06/22.
//

import Foundation

class TransactionViewModel {
    
    // MARK: - Private
    private let service: CoreDataManager
    private(set) var fetchedData: [TransactionModel] = []
    private(set) var sortedFetchedData: [ProductModel] = []
    
    init(service: CoreDataManager = CoreDataManager.shared){
        self.service = service
    }
    
    // MARK: - Events
    var didError: ((Error) -> Void)?
    var didUpdate: ((TransactionViewModel?) -> Void)?
    var didSelect: ((TransactionModel) -> Void)?
    
    var bindViewModelToController : ((ProductVCVIewModel) -> Void)?
}

extension TransactionViewModel {
    func fetchProductData() {
        var old = service.fetchAllTransaction() ?? []
        
        self.fetchedData = old.map { transaction -> TransactionModel in
            guard let id = transaction.id else { return TransactionModel.initEmpty() }
            let productData = service.fetchProductsOfTransaction(transactionID: id)
            var transactionWithProduct = transaction
            transactionWithProduct.productTransactions = productData
            return transactionWithProduct
        }
        //self.fetchedData = service.fetchAllTransaction() ?? []
        
        didUpdate?(self)
    }
    
    func transactionDetailVCViewModel(index: Int) -> DetailTransactionViewModel{
        let viewModel = DetailTransactionViewModel(data: self.fetchedData[index])
        return viewModel
    }
    
}
