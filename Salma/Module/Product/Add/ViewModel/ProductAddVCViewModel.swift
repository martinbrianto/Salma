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
    private(set) var data: ProductModel?
    
    init(service: CoreDataManager = CoreDataManager.shared, data: ProductModel?){
        self.data = data
        self.service = service
    }
    
    // MARK: - Events
    var didError: ((Error) -> Void)?
    var didSave: ((ProductAddVCViewModel?) -> Void)?
    var didDelete: ((ProductAddVCViewModel?) -> Void)?
    var didUpdate: ((ProductAddVCViewModel?) -> Void)?
    var didSelect: ((ProductModel) -> Void)?
    var didUpdateData: ((ProductAddVCViewModel?) -> Void)?
    
}

extension ProductAddVCViewModel {
    func fetchProductData() {
        didUpdate?(self)
    }
    
    func saveProduct(data: ProductModel){
        service.saveProduct(newProduct: data)
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
    
    func convertToData(image: UIImage?) -> Data? {
        if let imageData = image?.jpegData(compressionQuality: 0.75) {
            return imageData
        }
        return nil
    }
    
    func getImageFromData(imageData: Data?) -> UIImage? {
        if let imageData = imageData {
            return UIImage(data: imageData)
        }
        return nil
    }
    
    
}

