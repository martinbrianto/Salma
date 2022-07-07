//
//  Enum.swift
//  Salma
//
//  Created by Gratianus Martin on 4/12/22.
//

import Foundation

enum Status: String {
    case notPaid = "Not Paid"
    case inProgress = "In Progress"
    case completed = "Completed"
}

enum StoreProfilePageEntryPoint {
    case onboarding
    case onboardingExistingUser
    case settingPage
}

enum ProductPageState {
    case addCustom
    case add
    case edit
    case details
}

enum Section: String{
    case transaction = "Transaction"
    case custom = "Custom"
}

enum AutotextPageState {
    case add
    case editCustom
    case editDefault
    case detailCustom
    case detailDefault
}

enum TransactionPageState {
    case add
    case edit
    case detail
}

enum TransactionHeaderType: String {
    case customerData = "Customer Data"
    case address = "Address"
    case productDetails = "Product Details"
    case shippingDetails = "Shipping Details"
    case totalPrice = "Total Price"
}

enum TransactionTextfieldType: Int, CaseIterable {
    case customerName = 0
    case customerPhoneNumber = 1
    case addressName = 2
    case addressProvince = 3
    case addressCity = 4
    case addressDistrict = 5
    case addressPostalCode = 6
    case addProduct = 7
    case productNote = 8
    case shippingExpedition = 9
    case shippingPrice = 10
    case productCell
    case totalPrice
    
    var tfTitle: String {
        switch self {
        case .customerName:
            return "Customer Name"
        case .customerPhoneNumber:
            return "Phone Number"
        case .addressName:
            return "Address Name"
        case .addressProvince:
            return "Province"
        case .addressCity:
            return "City"
        case .addressDistrict:
            return "District"
        case .addressPostalCode:
            return "Postal Code"
        case .addProduct:
            return "Product"
        case .productNote:
            return "Notes"
        case .shippingExpedition:
            return "Expedition"
        case .shippingPrice:
            return "Shipping Price"
        default:
            return ""
        }
    }
    
    var tfPlaceholder: String {
        switch self {
        case .customerName:
            return "Customer name"
        case .customerPhoneNumber:
            return "Phone number"
        case .addressName:
            return "Street name, house number"
        case .addressProvince:
            return "Province"
        case .addressCity:
            return "City"
        case .addressDistrict:
            return "District"
        case .addressPostalCode:
            return "Postal code"
        case .productNote:
            return "Additional notes (optional)"
        case .shippingExpedition:
            return "Expedition"
        case .shippingPrice:
            return "Shipping price"
        case .addProduct:
            return "0 Product(s) chosen"
        default:
            return ""
        }
    }
}

enum TransactionProductType {
    case addCustomButton
    case product
}

enum DeepLink: String {
    case addTransaction = "addTransaction"
    case addAutotext = "addAutotext"
}
