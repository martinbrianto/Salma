//
//  Product+CoreDataProperties.swift
//  Salma
//
//  Created by gratianus.brianto on 09/05/22.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var image: Data?
    @NSManaged public var name: String
    @NSManaged public var price: Float
    @NSManaged public var weight: Int32
    @NSManaged public var uuid: UUID
    @NSManaged public var isActive: Bool
    @NSManaged public var referenceCount: Int32
    @NSManaged public var ofTransactionProduct: NSSet?

}

// MARK: Generated accessors for ofTransactionProduct
extension Product {

    @objc(addOfTransactionProductObject:)
    @NSManaged public func addToOfTransactionProduct(_ value: TransactionProduct)

    @objc(removeOfTransactionProductObject:)
    @NSManaged public func removeFromOfTransactionProduct(_ value: TransactionProduct)

    @objc(addOfTransactionProduct:)
    @NSManaged public func addToOfTransactionProduct(_ values: NSSet)

    @objc(removeOfTransactionProduct:)
    @NSManaged public func removeFromOfTransactionProduct(_ values: NSSet)

}

extension Product : Identifiable {

}
