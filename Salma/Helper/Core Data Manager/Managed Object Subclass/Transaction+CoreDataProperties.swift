//
//  Transaction+CoreDataProperties.swift
//  Salma
//
//  Created by gratianus.brianto on 09/05/22.
//
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var address_city: String
    @NSManaged public var address_district: String
    @NSManaged public var address_name: String
    @NSManaged public var address_postal_code: String
    @NSManaged public var address_province: String
    @NSManaged public var customer_name: String
    @NSManaged public var customer_phone_number: String
    @NSManaged public var date_completed: Date?
    @NSManaged public var date_created: Date
    @NSManaged public var date_paid: Date?
    @NSManaged public var note: String?
    @NSManaged public var price_subTotal: Float
    @NSManaged public var price_Total: Float
    @NSManaged public var shipping_expedition: String
    @NSManaged public var shipping_price: Float
    @NSManaged public var status: String
    @NSManaged public var uuid: UUID
    @NSManaged public var transactionProducts: NSOrderedSet?

}

// MARK: Generated accessors for transactionProducts
extension Transaction {

    @objc(insertObject:inTransactionProductsAtIndex:)
    @NSManaged public func insertIntoTransactionProducts(_ value: TransactionProduct, at idx: Int)

    @objc(removeObjectFromTransactionProductsAtIndex:)
    @NSManaged public func removeFromTransactionProducts(at idx: Int)

    @objc(insertTransactionProducts:atIndexes:)
    @NSManaged public func insertIntoTransactionProducts(_ values: [TransactionProduct], at indexes: NSIndexSet)

    @objc(removeTransactionProductsAtIndexes:)
    @NSManaged public func removeFromTransactionProducts(at indexes: NSIndexSet)

    @objc(replaceObjectInTransactionProductsAtIndex:withObject:)
    @NSManaged public func replaceTransactionProducts(at idx: Int, with value: TransactionProduct)

    @objc(replaceTransactionProductsAtIndexes:withTransactionProducts:)
    @NSManaged public func replaceTransactionProducts(at indexes: NSIndexSet, with values: [TransactionProduct])

    @objc(addTransactionProductsObject:)
    @NSManaged public func addToTransactionProducts(_ value: TransactionProduct)

    @objc(removeTransactionProductsObject:)
    @NSManaged public func removeFromTransactionProducts(_ value: TransactionProduct)

    @objc(addTransactionProducts:)
    @NSManaged public func addToTransactionProducts(_ values: NSOrderedSet)

    @objc(removeTransactionProducts:)
    @NSManaged public func removeFromTransactionProducts(_ values: NSOrderedSet)

}

extension Transaction : Identifiable {

}
