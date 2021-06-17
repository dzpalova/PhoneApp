//
//  Favorite+CoreDataProperties.swift
//  PhoneAppContacts
//
//  Created by Daniela Palova on 16.06.21.
//
//

import Foundation
import CoreData


extension Favorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorite> {
        return NSFetchRequest<Favorite>(entityName: "Favorite")
    }

    @NSManaged public var number: String?
    @NSManaged public var typeCall: String?
    @NSManaged public var contact: Contact?

}

extension Favorite : Identifiable {

}
