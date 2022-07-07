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
    private(set) var displayedData: [TransactionModel] = []
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
    
    func fetchTransactionData() {
        self.fetchedData = service.fetchAllTransaction() ?? []
        didUpdate?(self)
    }
    
    func fetchData() {
        let data = service.fetchAllTransaction() ?? []
        self.fetchedData = data
        filterToAll()
        didUpdate?(self)
    }
    
    func filterToNotPaid() {
        let filteredData = fetchedData.filter({
            $0.status == .notPaid
        })
        displayedData = filteredData
        didUpdate?(self)
    }
    
    func filterToInProgress() {
        let filteredData = fetchedData.filter({
            $0.status == .inProgress
        })
        displayedData = filteredData
        didUpdate?(self)
    }
    
    func filterToCompleted() {
        let filteredData = fetchedData.filter({
            $0.status == .completed
        })
        displayedData = filteredData
        didUpdate?(self)
    }
    
    func filterToAll() {
        displayedData = fetchedData
        didUpdate?(self)
    }
    
    func transactionDetailVCViewModel(index: Int) -> DetailTransactionViewModel {
        let viewModel = DetailTransactionViewModel(id: self.displayedData[index].id)
        return viewModel
    }
    
}
