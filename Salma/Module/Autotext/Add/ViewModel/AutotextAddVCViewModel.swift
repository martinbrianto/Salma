//
//  AutotextAddVCViewModel.swift
//  Salma
//
//  Created by gratianus.brianto on 11/05/22.
//

import Foundation

class AutotextAddVCViewModel {
    
    // MARK: - Privates
    private let service: CoreDataManager
    private(set) var data: Autotext?
    
    init(service: CoreDataManager = CoreDataManager.shared, data: Autotext?){
        self.data = data
        self.service = service
    }
    
    // MARK: - Events
    var didError: ((Error) -> Void)?
    var didUpdate: (() -> Void)?
    var didSave: ((AutotextAddVCViewModel?) -> Void)?
    var didDelete: ((AutotextAddVCViewModel?) -> Void)?
    var didUpdateData : ((AutotextAddVCViewModel?) -> Void)?
    var didSelect: ((Autotext) -> Void)?
    
    var bindViewModelToController : ((AutotextAddVCViewModel) -> Void)?
}

extension AutotextAddVCViewModel {
    func fetchAutotext(){
        if data != nil {
            didUpdate?()
        }
    }
    
    func saveAutotext(data: Autotext){
        service.saveCustomAutotext(autotextData: data)
        didSave?(self)
    }
    
    func updateAutotext(pageState: AutotextPageState, data: Autotext, id: UUID) {
        if pageState == .editDefault {
            service.updateDefaultAutotext(autotextID: id, newAutotextData: data)
        } else if pageState == .editCustom {
            service.updateCustomAutotext(autotextID: id, newAutotextData: data)
        }
        self.data = data
        didUpdateData?(self)
    }
    
    func deleteAutotext(id: UUID) {
        service.deleteCustomAutotext(autotextID: id)
        didDelete?(self)
    }
}
