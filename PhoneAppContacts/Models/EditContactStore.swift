//
//  EditContactStore.swift
//  RecentCalls
//
//  Created by Daniela Palova on 31.05.21.
//

import UIKit

enum TypeSection: Int, CaseIterable {
    case names
    case number
    case email
    case ringTone
    case textTone
    case url
    case address
    case birthday
    case date
    case relatedName
    case socialProfile
    case instantMessage
    case notes
}

enum EditContactItemType: String, Codable {
    case textField
    case addItem
    case removeItem
    case removeAddress
    case removeDate
    case detail
    case text
    case notes
}

struct EditContactItem: Codable {
    var name: String!
    var type: EditContactItemType!
    var detail: String!
}

class EditContactStore {
    var items = [[EditContactItem]]()
    
    init(contact: Contact, contactInfo: ContactInfo) {
        do {
            if let url = Bundle.main.url(forResource: "ContactEditOptions", withExtension: "json") {
                let data = try Data(contentsOf: url)
                items = try JSONDecoder().decode([[EditContactItem]].self, from: data)
            }
        } catch {
            print("Error while decoding cells data: \(error)")
        }
        
        items[0][0].detail = contact.firstName
        items[0][1].detail = contact.lastName
        items[0][2].detail = contact.company
        
        let contactInfo = contactInfo.getContactArr()
        var idxToInsert = 0
        
        for itemArr in contactInfo {
            idxToInsert = TypeSection.allCases[idxToInsert] == .email ? TypeSection.url.rawValue : idxToInsert + 1

            for item in itemArr.reversed() {
                var type: EditContactItemType = [TypeSection.birthday.rawValue, TypeSection.date.rawValue].contains(idxToInsert) ? .removeDate : .removeItem
                type = TypeSection.address.rawValue == idxToInsert ? .removeAddress : type

                let newItem = EditContactItem(name: item.type, type: type, detail: item.value)
                items[idxToInsert].insert(newItem, at: 0)
            }
        }
    }
    
    var numSections: Int {
        return items.count
    }
    
    func numRowsInSection(_ section: Int) -> Int {
        return items[section].count
    }
    
    func getItem(at idx: IndexPath) -> EditContactItem {
        return items[idx.section][idx.row]
    }
}
