//
//  ProductAddVCViewModel.swift
//  Salma
//
//  Created by Sugiharso Wijaya on 12/05/22.
//

import Foundation
import UIKit

class ProductAddVCViewModel {
    
    // MARK: - private
    private let service: CoreDataManager
    private(set) var fetchedData: [ProductModel] = []
    private(set) var sortedFetchedData: [ProductModel] = []
    
    init(service: CoreDataManager = CoreDataManager.shared){
        self.service = service
    }
    
    // MARK: - Events
    var didError: ((Error) -> Void)?
    var didSave: ((ProductAddVCViewModel?) -> Void)?
    var didDelete: ((ProductAddVCViewModel?) -> Void)?
    var didUpdate: ((ProductAddVCViewModel?) -> Void)?
    var didSelect: ((ProductModel) -> Void)?
    
}

extension ProductAddVCViewModel {
    func fetchProductData() {
        self.fetchedData = service.fetchAllProduct() ?? []
//        sortLatestTransaction()
        didUpdate?(self)
    }
    
//    func sortLatestTransaction() {
//        if !fetchedData.isEmpty {
//            let firstTenElements = fetchedData.prefix(10)
//            self.sortedFetchedData = firstTenElements.sorted(by: {$0.dateCreated!.compare($1.dateCreated!) == .orderedAscending})
//        }
//    }
    
    func getSellerProfileName() -> String {
        let storeProfile = service.fetchStoreProfile()
        return storeProfile?.name ?? ""
    }
    
}

