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
let customAutotextTagData = ["#storeName", "#storeURL", "#storeLocation", "#storePhoneNumber"]
