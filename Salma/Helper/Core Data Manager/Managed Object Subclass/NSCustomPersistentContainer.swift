//
//  NSCustomPersistentContainer.swift
//  Salma
//
//  Created by gratianus.brianto on 27/06/22.
//

import Foundation
import CoreData

class NSCustomPersistentContainer: NSPersistentCloudKitContainer {
    
    override open class func defaultDirectoryURL() -> URL {
        guard var storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.salma") else {
            fatalError("Shared file container could not be created.")
        }
        storeURL = storeURL.appendingPathComponent("Salma.sqlite")
        return storeURL
    }

}
