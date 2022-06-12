//
//  Transaction.swift
//  Salma
//
//  Created by gratianus.brianto on 20/04/22.
//

import Foundation
import UIKit

struct TransactionModel {
    var id: UUID?
    var status: Status
    var dateCreated: Date?
    var datePaid: Date?
    var dateCompleted: Date?
    var customerName: String
    var customerPhoneNumber: String
    var addressName: String
    var addressProvince: String
    var addressCity: String
    var addressDistrict: String
    var addressPostalCode: String
    var notes: String?
    var expedition: String
    var shippingPrice: Float
    var priceSubTotal: Float
    var priceTotal: Float
    var productTransactions: [ProductModel]?
    
    static func initEmpty() -> TransactionModel {
        return TransactionModel(id: UUID(),
                                status: .notPaid,
                                dateCreated: nil,
                                datePaid: nil,
                                dateCompleted: nil,
                                customerName: "",
                                customerPhoneNumber: "",
                                addressName: "",
                                addressProvince: "",
                                addressCity: "",
                                addressDistrict: "",
                                addressPostalCode: "",
                                notes: "",
                                expedition: "",
                                shippingPrice: 0,
                                priceSubTotal: 0,
                                priceTotal: 0,
                                productTransactions: nil)
        
    }
}

struct TransactionPrice {
    var shippingPrice: Float
    var priceSubTotal: Float
    var priceTotal: Float
}
