//
//  Product.swift
//  Salma
//
//  Created by gratianus.brianto on 09/05/22.
//

import Foundation
import UIKit

struct ProductModel {
    var image: UIImage?
    var id: UUID?
    var name: String
    var price: Float
    var weight: Int32
    var quantity: Int32?
    var isActive: Bool?
}
