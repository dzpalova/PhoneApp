//
//  RecentCall+CoreDataProperties.swift
//  PhoneAppContacts
//
//  Created by Daniela Palova on 18.06.21.
//
//

import Foundation
import CoreData


extension RecentCall {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecentCall> {
        return NSFetchRequest<RecentCall>(entityName: "RecentCall")
    }

    @NSManaged public var date: Date?
    @NSManaged public var isMissed: Bool
    @NSManaged public var isOutcome: Bool
    @NSManaged public var number: String?
    @NSManaged public var type: String?
    @NSManaged public var timeInSeconds: Int64
    @NSManaged public var contact: Contact?

}

extension RecentCall : Identifiable {

}
