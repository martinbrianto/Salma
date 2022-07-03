//
//  Autotext.swift
//  Salma
//
//  Created by gratianus.brianto on 09/05/22.
//

import Foundation

struct Autotext {
    var title: String
    var messages: String
    var id: UUID?
}

let formatOrderTagData = ["#name", "#phoneNumber", "#streetAddress", "#province", "#city", "#district", "#postalCode", "#notes", "#expedition"]
let defaultAutotextTagData = ["#storeName", "#storeURL", "#storeLocation", "#storePhoneNumber", "#customerName", "#customerPhoneNumber", "#customerAddress", "#products", "#shippingExpedition", "#shippingPrice", "#totalPrice"]
let customAutotextTagData = ["#storeName", "#subTotalPrice", "#storeURL", "#storeLocation", "#storePhoneNumber"]

enum defaultAutoTextTagData: String, Hashable, Equatable, CaseIterable {
    case storeName = "#storeName"
    case storeURL = "#storeURL"
    case storeLocation = "#storeLocation"
    case storePhoneNumber = "#storePhoneNumber"
    case customerName = "#customerName"
    case customerPhoneNumber = "#customerPhoneNumber"
    case customerAddress = "#customerAddress"
    case products = "#products"
    case shippingExpedition = "#shippingExpedition"
    case shippingPrice = "#shippingPrice"
    case subTotalPrice = "#subTotalPrice"
    case totalPrice = "#totalPrice"
}

enum customAutoTextTagData: String, Equatable, CaseIterable {
    case storeName = "#storeName"
    case storeURL = "#storeURL"
    case storeLocation = "#storeLocation"
    case storePhoneNumber = "#storePhoneNumber"
}
