//
//  Network.swift
//  Salma
//
//  Created by gratianus.brianto on 05/07/22.
//

import Foundation
import Alamofire

struct LocationResponse: Codable {
    let success: Bool
    let areas: [SingleArea]
}

struct SingleArea: Codable {
    let name: String
    let postal_code: Int 
}

struct ShippingResponse: Codable {
    let success: Bool
    let object: String
    let message: String
    let code: Int
    let pricing: [Pricing]
}

struct ShippingRequest: Encodable {
    
    let origin_postal_code: Int
    let destination_postal_code: Int
    let couriers: String
    let items: [ShipmentItem]
}

struct ShipmentItem: Codable {
    let weight: Int
}

struct Pricing: Codable {
    let courier_name: String
    let courier_service_name: String
    let duration: String
    let price: Int
}
