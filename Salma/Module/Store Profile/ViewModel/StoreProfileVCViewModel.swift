//
//  StoreProfileVCViewModel.swift
//  Salma
//
//  Created by gratianus.brianto on 10/05/22.
//

import Foundation

class StoreProfileVCViewModel {
    
    // MARK: - Privates
    private let service: CoreDataManager
    private(set) var fetchedData: StoreProfile?
    private(set) var fetchedLocation: SingleArea?
    
    init(service: CoreDataManager = CoreDataManager.shared){
        self.service = service
    }
    
    // MARK: - Events
    var didError: ((Error) -> Void)?
    var didUpdate: ((StoreProfileVCViewModel?) -> Void)?
    var bindViewModelToController : ((StoreProfileVCViewModel) -> Void)?
    
}

extension StoreProfileVCViewModel {
    func fetchStoreProfile() {
        self.fetchedData = service.fetchStoreProfile()
        self.fetchedLocation = fetchedData?.location
        didUpdate?(self)
    }
    
    func updateStoreProfile(_ newProfileData: StoreProfile ){
        service.updateProfile(newProfileData: newProfileData)
    }
    
    func saveStoreProfile(_ profileData: StoreProfile) {
        service.saveProfile(newProfile: profileData)
    }
    
    func receiveStoreLocation(location: SingleArea){
        self.fetchedLocation = location
    }
}
