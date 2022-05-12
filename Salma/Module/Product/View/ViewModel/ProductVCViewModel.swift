//
//  ProductVCViewModel.swift
//  Salma
//
//  Created by Sugiharso Wijaya on 12/05/22.
//

import Foundation
import UIKit

class ProductVCVIewModel {
    
    // MARK: - Private
    private let service: CoreDataManager
    private(set) var fetchedData: [ProductModel] = []
    private(set) var sortedFetchedData: [ProductModel] = []
    
    init(service: CoreDataManager = CoreDataManager.shared){
        self.service = service
    }
    
    // MARK: - Events
    var didError: ((Error) -> Void)?
    var didUpdate: ((ProductVCVIewModel?) -> Void)?
    var didSelect: ((ProductModel) -> Void)?
    
    var bindViewModelToController : ((ProductVCVIewModel) -> Void)?
}

extension ProductVCVIewModel {
    func fetchProductData() {
        self.fetchedData = service.fetchAllProduct() ?? []
        didUpdate?(self)
    }
    
    func navigateToDetailProduct(_ vc : DashboardViewController) {
        //todo: navigate to detail
    }
    
}

