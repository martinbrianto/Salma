//
//  Formatter+Extension.swift
//  Salma
//
//  Created by gratianus.brianto on 21/04/22.
//

import Foundation

extension NumberFormatter {
    static let rpFormat: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "Rp"
        formatter.currencyGroupingSeparator = "."
        formatter.currencyDecimalSeparator = ","
        return formatter
    }()
}

extension Numeric {
    var formattedToRp: String {
        return NumberFormatter.rpFormat.string(for: self) ?? ""
    }
}
