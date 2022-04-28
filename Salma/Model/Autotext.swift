//
//  Autotext.swift
//  Salma
//
//  Created by Sugiharso Wijaya on 26/04/22.
//

import Foundation

struct Autotext {
    var section: Section
    var title: String
    var message: String
}

var autotextList: [Autotext] = [
    transAT1,
    transAT2,
    transAT3,
    transAT4,
    customAT1,
    customAT2,
    customAT3,
    customAT4
]

var transAT1 = Autotext(
    section: .transaction,
    title: "Format order",
    message: "Format order"
)

var transAT2 = Autotext(
    section: .transaction,
    title: "Unpaid order",
    message: "Unpaid order"
)

var transAT3 = Autotext(
    section: .transaction,
    title: "Paid order",
    message: "Paid order"
)

var transAT4 = Autotext(
    section: .transaction,
    title: "Shipped order",
    message: "Shipped order"
)

var customAT1 = Autotext(
    section: .custom,
    title: "Thank you",
    message: "Thank you"
)

var customAT2 = Autotext(
    section: .custom,
    title: "Hello",
    message: "Hello"
)

var customAT3 = Autotext(
    section: .custom,
    title: "Ready stock",
    message: "Ready stock"
)

var customAT4 = Autotext(
    section: .custom,
    title: "Empty stock",
    message: "Empty stock"
)
