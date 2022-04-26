//
//  Transaction.swift
//  Salma
//
//  Created by gratianus.brianto on 20/04/22.
//

import Foundation
import UIKit

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
    var image: UIImage?
    var title: String
    var price: Float
    var weight: Int
}

var productDummy1 = Product(
    image: UIImage(named: "tumbler"),
    title: "Tublr",
    price: 10000000,
    weight: 10
)
var productDummy2 = Product(
    image: UIImage(named: "air jordan 6 university blue"),
    title: "Air Jordan / Brand New In Box (Mint...",
    price: 10000000,
    weight: 10
)
var productDummy3 = Product(
    image: nil,
    title: "Phone",
    price: 10000000,
    weight: 10
)

var productList: [Product] = [
    productDummy1,
    productDummy2,
    productDummy3
]
