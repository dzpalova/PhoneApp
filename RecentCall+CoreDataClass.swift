//
//  RecentCall+CoreDataClass.swift
//  PhoneAppContacts
//
//  Created by Daniela Palova on 16.06.21.
//
//

import Foundation
import CoreData

@objc(RecentCall)
public class RecentCall: NSManagedObject {
    func saveData() {
        do {
            try AllContactsStore.viewContext.save()
        } catch {
            print("Error saving to Core Data", error)
        }
    }
}
