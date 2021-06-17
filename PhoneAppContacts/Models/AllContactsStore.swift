import UIKit
import Foundation
import CoreData

struct AllContactsStore: Sequence {
    static var shared = AllContactsStore()
    
    private var contacts: [[Contact]]
    private var existingSections = Set<Character>()
    
    static let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PhoneApp")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error setting up Core Data (\(error)).")
            }
        }
        return container
    }()
    
    static let viewContext = persistentContainer.viewContext
    
    var numSections: Int {
        return contacts.count
    }
        
    mutating func parseData(_ data: [Contact]) {
        for cont in data {
            let name = cont.firstName ?? ""
            let firstLetter = name.first ?? Character(" ")

            if existingSections.contains(Character(firstLetter.uppercased())) {
                var idxSection = 0
                for i in 0 ..< contacts.count {
                    if contacts[i].first!.firstName?.first ?? " " == firstLetter {
                        idxSection = i
                        break
                    }
                }
                contacts[idxSection].append(cont)
                contacts[idxSection].sort { $0.firstName ?? "" < $1.firstName ?? "" }
            } else {
                existingSections.insert(Character(firstLetter.uppercased()))
                contacts.append([cont])
                if contacts.count > 2 {
                    contacts.sort { $0.first!.firstName ?? "" < $1.first!.firstName ?? ""}
                }
            }
        }
    }

    init() {
        contacts = []
        let allContacts = loadData()
        parseData(allContacts)
    }
    
    private func loadData() -> [Contact] {
        var allContacts = [Contact]()
        let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
        let sortByName = NSSortDescriptor(key: #keyPath(Contact.firstName), ascending: true)
        fetchRequest.sortDescriptors = [sortByName]

        do {
            allContacts = try Self.viewContext.fetch(fetchRequest)
            
        } catch {
            print("Error loading contacts",error)
        }
        if allContacts.isEmpty {
            let contact = Contact(context: Self.viewContext)
            contact.firstName = "Gigi"
            contact.otherInformation = """
                            {
                                "number":
                                [
                                    {
                                        "type": "home",
                                        "value": "088 4346631"
                                    }
                                ],
                                "email":
                                [
                                    {
                                        "type": "work",
                                        "value": "55555555@abv.bg"
                                    }
                                ],
                                "ringtone": "Default",
                                "textTone": "Default",
                                "url": [],
                                "address":
                                [
                                    {
                                        "type": "home",
                                        "value": {
                                            "street": "",
                                            "city": "Sofia",
                                            "state": "",
                                            "ZIP": "1000",
                                            "country": "Bulgaria"
                                        }
                                    }
                                ],
                                "birthday":
                                [
                                    {
                                        "type": "birthday",
                                        "value": "January 24, 1985"
                                    }
                                ],
                                "date": [],
                                "relatedName": [],
                                "socialProfile": [],
                                "instantMessage": [],
                            }
                            """
            allContacts.append(contact)
        }
        
        do {
            try Self.viewContext.save()
        } catch {
            print("Error saving to Core Data", error)
        }
        
        return allContacts
    }
    
    func makeIterator() -> AnyIterator<Contact> {
        var innerIdx = 0
        var outerIdx = 0
        return AnyIterator<Contact> {
            if innerIdx == self.contacts[outerIdx].count {
                innerIdx = 0
                outerIdx += 1
                if outerIdx == self.contacts.count {
                    outerIdx = 0
                    innerIdx = 0
                    return nil
                }
            }
            defer { innerIdx += 1 }
            return self.contacts[outerIdx][innerIdx]
        }
    }
    
    func getContact(_ indexPath: IndexPath) -> Contact {
        return contacts[indexPath.section][indexPath.row]
    }
    
    func getContact(_ name: String) -> Contact? {
        return self.first { name == ($0.firstName ?? " ") + " " + ($0.lastName ?? " ") }
    }
    
    func rowsInSection(_ section: Int) -> Int {
        return contacts[section].count
    }
    
    func titleSection(_ section: Int) -> String? {
        return contacts[section].count != 0 ? String((contacts[section][0].firstName ?? "" ).first ?? " ") : nil
    }
    
    mutating func clearAll() {
        contacts = []
        existingSections.removeAll()
    }
}
