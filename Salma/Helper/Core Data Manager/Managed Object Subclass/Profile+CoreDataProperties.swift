//
//  Profile+CoreDataProperties.swift
//  Salma
//
//  Created by gratianus.brianto on 08/05/22.
//
//

import Foundation
import CoreData


extension Profile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Profile> {
        return NSFetchRequest<Profile>(entityName: "Profile")
    }

    @NSManaged public var storeLocation: String
    @NSManaged public var storeName: String
    @NSManaged public var storePhoneNumber: String
    @NSManaged public var storeURL: String

}

extension Profile : Identifiable {

}
