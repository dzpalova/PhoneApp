//
//  Contact+CoreDataProperties.swift
//  PhoneAppContacts
//
//  Created by Daniela Palova on 16.06.21.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var company: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var notes: String?
    @NSManaged public var otherInformation: String?
    @NSManaged public var photoName: String?
    @NSManaged public var favourites: NSSet?
    @NSManaged public var recents: NSSet?

}

// MARK: Generated accessors for favourites
extension Contact {

    @objc(addFavouritesObject:)
    @NSManaged public func addToFavourites(_ value: Favorite)

    @objc(removeFavouritesObject:)
    @NSManaged public func removeFromFavourites(_ value: Favorite)

    @objc(addFavourites:)
    @NSManaged public func addToFavourites(_ values: NSSet)

    @objc(removeFavourites:)
    @NSManaged public func removeFromFavourites(_ values: NSSet)

}

// MARK: Generated accessors for recents
extension Contact {

    @objc(addRecentsObject:)
    @NSManaged public func addToRecents(_ value: RecentCall)

    @objc(removeRecentsObject:)
    @NSManaged public func removeFromRecents(_ value: RecentCall)

    @objc(addRecents:)
    @NSManaged public func addToRecents(_ values: NSSet)

    @objc(removeRecents:)
    @NSManaged public func removeFromRecents(_ values: NSSet)

}

extension Contact : Identifiable {

}
