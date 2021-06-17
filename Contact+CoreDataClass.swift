//
//  Contact+CoreDataClass.swift
//  PhoneAppContacts
//
//  Created by Daniela Palova on 16.06.21.
//
//

import Foundation
import CoreData

@objc(Contact)
public class Contact: NSManagedObject {
    func getFullName() -> String {
        if firstName == nil || firstName == "" {
            return lastName ?? " "
        }
        return lastName == nil || lastName == "" ? firstName! : firstName! + " " + lastName!
    }
    
    func getContactInfo() -> ContactInfo {
        let data = self.otherInformation?.data(using: .utf8)
        var contactInfo = ContactInfo()
        do {
            contactInfo = try JSONDecoder().decode(ContactInfo.self, from: data!)
        } catch {
            print("Error decodint contact data", error)
        }
        return contactInfo
    }
    
    func saveEditedItem(contactInfo: ContactInfo) {
        do {
            let information = try JSONEncoder().encode(contactInfo)
            self.otherInformation = String(data: information, encoding: .utf8)
        } catch {
            print("Error while encoding contact information", error)
        }
        
        do {
            try AllContactsStore.viewContext.save()
        } catch {
            print("Error saving to Core Data", error)
        }
    }
    
    func delete() {
        AllContactsStore.viewContext.delete(self)
        do {
            try AllContactsStore.viewContext.save()
        } catch {
            print("Error saving to Core Data", error)
        }
    }
}
