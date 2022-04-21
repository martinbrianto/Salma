//
//  Transaction.swift
//  Salma
//
//  Created by gratianus.brianto on 20/04/22.
//

import Foundation

struct Transaction {
    var status: Status
    var customerName: String
    var phoneNumber: String
    var address: String
    var province: String
    var city: String
    var district: String
    var postalCode: String
    var products: [Product]
    var notes: String?
    var expedition: String
    var shippingPrice: Int
    var priceSubtotal: Int
    var priceTotal: Int
}

struct Product {
    var image: String
    var name: String
    var price: String
    var weight: Int
}
