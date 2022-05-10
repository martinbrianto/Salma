//
//  DashboardVCViewModel.swift
//  Salma
//
//  Created by gratianus.brianto on 11/04/22.
//

import Foundation
import UIKit

class DashboardVCViewModel {
    
    // MARK: - Private
    private let service: CoreDataManager
    private(set) var fetchedData: [TransactionModel] = []
    private(set) var sortedFetchedData: [TransactionModel] = []
    
    init(service: CoreDataManager = CoreDataManager.shared){
        self.service = service
    }
    
    // MARK: - Events
    var didError: ((Error) -> Void)?
    var didUpdate: ((DashboardVCViewModel?) -> Void)?
    var didSelect: ((TransactionModel) -> Void)?
    private(set) var isUpdating: Bool = false {
        didSet {
            didUpdate?(self)
        }
    }
    
    var bindViewModelToController : ((DashboardVCViewModel) -> Void)?
}

extension DashboardVCViewModel {
    func fetchTransactionData() {
        self.fetchedData = service.fetchAllTransaction() ?? []
        sortLatestTransaction()
        didUpdate?(self)
    }
    
    func calculateTotalPenjualan() -> Float {
        if !fetchedData.isEmpty {
            let doneTransaction = fetchedData.filter{$0.status == .completed }
            let totalPenjualan = doneTransaction.map{ $0.priceTotal }.reduce(0, +)
            return totalPenjualan
        } else {
            return 0
        }
    }
    
    func sortLatestTransaction() {
        if !fetchedData.isEmpty {
            let firstTenElements = fetchedData.prefix(10)
            self.sortedFetchedData = firstTenElements.sorted(by: {$0.dateCreated!.compare($1.dateCreated!) == .orderedAscending})
        }
    }
    
    func navigateToDetailProduct(_ vc : DashboardViewController) {
        //todo: navigate to detail
    }
    
    func getSellerProfileName() -> String {
        let storeProfile = CoreDataManager.shared.fetchStoreProfile()
        return storeProfile?.name ?? ""
    }
    
}
