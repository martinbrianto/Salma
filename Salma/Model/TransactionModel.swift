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
}

struct TransactionPrice {
    var shippingPrice: Float
    var priceSubTotal: Float
    var priceTotal: Float
}
