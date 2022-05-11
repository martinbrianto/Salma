//
//  CustomAutotext+CoreDataProperties.swift
//  Salma
//
//  Created by gratianus.brianto on 08/05/22.
//
//

import Foundation
import CoreData


extension CustomAutotext {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CustomAutotext> {
        return NSFetchRequest<CustomAutotext>(entityName: "CustomAutotext")
    }

    @NSManaged public var messages: String
    @NSManaged public var title: String
    @NSManaged public var uuid: UUID

}

extension CustomAutotext : Identifiable {

}
