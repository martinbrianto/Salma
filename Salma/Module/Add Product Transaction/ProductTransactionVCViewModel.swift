//
//  ProductTransactionVCViewModel.swift
//  Salma
//
//  Created by gratianus.brianto on 10/06/22.
//

import Foundation

class ProductTransactionVCViewModel {
    // MARK: - Private
    private let service: CoreDataManager
    //private(set) var transaction: Transaction?
    
    var cell: [TransactionProductType] = []
    private(set) var productData: [ProductModel]
    private var oldProductData: [ProductModel]?
    
    init(service: CoreDataManager = CoreDataManager.shared, products: [ProductModel]?) {
        self.service = service
        self.productData = products ?? []
    }

    // MARK: - Events
    var didError: ((Error) -> Void)?
    var didSave: ((ProductTransactionVCViewModel?) -> Void)?
    var didUpdate: ((ProductTransactionVCViewModel?) -> Void)?
    var didUpdateProduct: ((ProductTransactionVCViewModel?) -> Void)?
}

extension ProductTransactionVCViewModel {
    func fetchProductData() {
        let fetchedProducts = [ProductModel(name: "Product 1", price: 1, weight: 1, quantity: 0, isActive: nil),ProductModel(name: "Product 2", price: 1, weight: 1, quantity: 0, isActive: nil)]
        var old = productData
        old.append(contentsOf: fetchedProducts)
        
        let filteredProductData = old.reduce([]) { (current, productData) -> [ProductModel] in
            var new = current
            if !new.contains(where:{$0.name == productData.name}) {
                new.append(productData)
            }
            return new
        }
        
        productData = filteredProductData
        
        cell = [.addCustomButton]
        if !productData.isEmpty {
            productData.forEach {_ in
                cell.append(.product)
            }
        }
        
        didUpdate?(self)
    }
    
    func addCustomProduct(_ customProduct: ProductModel) {
        self.productData.insert(customProduct, at: 0)
        cell.append(.product)
        didUpdateProduct?(self)
    }
    
    func updateQuantityOfProduct(index: Int, quantity: Int32) {
        self.productData[index].quantity = quantity
    }
    
    func saveProduct(data: TransactionModel){
        service.saveTransaction(transactionData: data)
        didSave?(self)
    }
}

