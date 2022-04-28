//
//  Autotext.swift
//  Salma
//
//  Created by Sugiharso Wijaya on 26/04/22.
//

import Foundation

struct Autotext {
    var title: String
    var message: String
}

var transactionAutotext: [Autotext] = [
    transAT1,
    transAT2,
    transAT3,
    transAT4
]

var customAutotext: [Autotext] = [
    customAT1,
    customAT2,
    customAT3,
    customAT4
]

var transAT1 = Autotext(
    title: "Format order",
    message: "Format order"
)

var transAT2 = Autotext(
    title: "Unpaid order",
    message: "Unpaid order"
)

var transAT3 = Autotext(
    title: "Paid order",
    message: "Paid order"
)

var transAT4 = Autotext(
    title: "Shipped order",
    message: "Shipped order"
)

var customAT1 = Autotext(
    title: "Thank you",
    message: "Thank you"
)

var customAT2 = Autotext(
    title: "Hello",
    message: "Hello"
)

var customAT3 = Autotext(
    title: "Ready stock",
    message: "Ready stock"
)

var customAT4 = Autotext(
    title: "Empty stock",
    message: "Empty stock"
)



