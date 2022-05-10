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
    case settingPage
}

enum Section: String{
    case transaction = "Transaction"
    case custom = "Custom"
}

enum AutotextPageState: String{
    case add = "Add"
    case edit = "Edit"
    case detail = "Detail"
}
