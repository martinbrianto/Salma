//
//  NSCustomPersistentContainer.swift
//  Salma
//
//  Created by gratianus.brianto on 27/06/22.
//

import Foundation
import CoreData

class NSCustomPersistentContainer: NSPersistentContainer {
    
    override open class func defaultDirectoryURL() -> URL {
        var storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.salma")
        storeURL = storeURL?.appendingPathComponent("Salma.sqlite")
        return storeURL!
    }

}
