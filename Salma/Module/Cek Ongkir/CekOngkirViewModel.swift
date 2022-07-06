//
//  CekOngkirViewModel.swift
//  Salma
//
//  Created by gratianus.brianto on 06/07/22.
//

import Foundation
import Alamofire

struct CekOngkirModel {
    var from: SingleArea
    var to: SingleArea
    var weight: Int
}

class CekOngkirViewModel {
    private(set) var data: CekOngkirModel?
    
    private(set) var from: SingleArea?
    private(set) var to: SingleArea?
    private(set) var weight: Int?
    
    init(from: SingleArea?, to: SingleArea?, weight: Int?){
        self.from = from
        self.to = to
        self.weight = weight
    }
    
    // MARK: - Events
    var didError: ((Error) -> Void)?
    var didUpdate: ((CekOngkirViewModel?) -> Void)?
    
}

extension CekOngkirViewModel {
    func shippingRateViewModel() -> ShippingRateViewModel? {
        
        if let from = from, let to = to, let weight = weight {
            self.data = CekOngkirModel(
                from: from,
                to: to,
                weight: weight
            )
        }
        
        if let data = self.data {
            let request = ShippingRequest(
                origin_postal_code: data.from.postal_code,
                destination_postal_code: data.to.postal_code,
                couriers: "jne,jnt",
                items: [
                    ShipmentItem(weight: data.weight)
                ]
            )
            let viewModel = ShippingRateViewModel(requestParams: request)
            return viewModel
        }
        return nil
    }
    
    func setFromLocation(_ data: SingleArea){
        self.from = data
    }
    
    func setToLocation(_ data: SingleArea){
        self.to = data
    }
    
    func setWeight(_ data: Int){
        self.weight = data
    }
    
    func setData(_ data: CekOngkirModel){
        if let from = from, let to = to, let weight = weight {
            self.data = CekOngkirModel(
                from: from,
                to: to,
                weight: weight
            )
        }
    }
}
