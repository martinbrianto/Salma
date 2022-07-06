//
//  ShippingRateViewModel.swift
//  Salma
//
//  Created by gratianus.brianto on 06/07/22.
//

import Foundation
import SwiftUI

class ShippingRateViewModel {
    private let requestParams: ShippingRequest
    var fetchedData: ShippingResponse?
    private(set) var isLoading: Bool = true {
        didSet {
            self.didLoading?(self)
        }
    }
    
    init(requestParams: ShippingRequest){
        self.requestParams = requestParams
    }
    
    // MARK: - Events
    var didError: ((Error) -> Void)?
    var didUpdate: ((ShippingRateViewModel?) -> Void)?
    var didLoading: ((ShippingRateViewModel?) -> Void)?
}

extension ShippingRateViewModel {
    func getShippingRate() {
        NetworkManager.shared.getshippingRate(requestParams) { response, error in
            if let response = response {
                self.fetchedData = response
                self.didUpdate?(self)
                self.isLoading = false
            } else {
                self.didError?(error!)
            }
        }
    }
    
}
