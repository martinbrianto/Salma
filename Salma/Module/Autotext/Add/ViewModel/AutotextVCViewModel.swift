//
//  AutotextVCViewModel.swift
//  Salma
//
//  Created by gratianus.brianto on 12/05/22.
//

import Foundation

class AutotextVCViewModel {
    
    // MARK: - Privates
    private let service: CoreDataManager
    private(set) var fetchedCustomAutotext: [Autotext] = []
    private(set) var fetchedDefaultAutotext: [Autotext] = []
    
    
    init(service: CoreDataManager = CoreDataManager.shared){
        self.service = service
    }
    
    // MARK: - Events
    var didError: ((Error) -> Void)?
    var didUpdate: ((AutotextVCViewModel?) -> Void)?
    var didSelect: ((Autotext) -> Void)?
}

extension AutotextVCViewModel {
    func fetchAutotextList(){
        fetchedCustomAutotext = service.fetchAllCustomAutotext() ?? []
        fetchedDefaultAutotext = service.fetchAllDefaultAutotext() ?? []
        didUpdate?(self)
    }
    
    func autotextAddVCViewModelCustomDetail(index: Int) -> AutotextAddVCViewModel {
        let viewModel = AutotextAddVCViewModel(data: self.fetchedCustomAutotext[index])
        return viewModel
    }
    
    func autotextAddVCViewModelDefaultDetail(index: Int) -> AutotextAddVCViewModel {
        let viewModel = AutotextAddVCViewModel(data: self.fetchedDefaultAutotext[index])
        return viewModel
    }
}
