//
//  DefaultAutotext+CoreDataProperties.swift
//  Salma
//
//  Created by gratianus.brianto on 08/05/22.
//
//

import Foundation
import CoreData


extension DefaultAutotext {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DefaultAutotext> {
        return NSFetchRequest<DefaultAutotext>(entityName: "DefaultAutotext")
    }

    @NSManaged public var messages: String
    @NSManaged public var title: String
    @NSManaged public var uuid: UUID

}

extension DefaultAutotext : Identifiable {

}
