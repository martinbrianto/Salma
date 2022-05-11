//
//  TransactionProduct+CoreDataProperties.swift
//  Salma
//
//  Created by gratianus.brianto on 09/05/22.
//
//

import Foundation
import CoreData


extension TransactionProduct {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TransactionProduct> {
        return NSFetchRequest<TransactionProduct>(entityName: "TransactionProduct")
    }

    @NSManaged public var productPrice: Float
    @NSManaged public var productQuantity: Int32
    @NSManaged public var ofTransaction: Transaction?
    @NSManaged public var product: Product

}

extension TransactionProduct : Identifiable {

}
