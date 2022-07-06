//
//  GetLocationViewModel.swift
//  Salma
//
//  Created by gratianus.brianto on 05/07/22.
//

import Foundation

class GetLocationViewModel {
    private(set) var fetchedData: LocationResponse?
    var isEmpty: Bool {
        return fetchedData == nil ? true : false
    }
    var isLoading: Bool = false {
        didSet {
            self.didLoading?(self)
        }
    }
    // MARK: - Events
    var didError: ((Error) -> Void)?
    var didUpdate: ((GetLocationViewModel?) -> Void)?
    var didLoading: ((GetLocationViewModel?) -> Void)?
    
}

extension GetLocationViewModel {
    func getLocation(location: String) {
        self.isLoading = true
        NetworkManager.shared.getSingleLocation(location) { response, error in
            if error == nil {
                self.fetchedData = response
                self.isLoading = false
                self.didUpdate?(self)
            }
        }
    }
}
