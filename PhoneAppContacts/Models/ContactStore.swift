//
//  ContactStore.swift
//  RecentCalls
//
//  Created by Daniela Palova on 31.05.21.
//

import UIKit

class ContactStore {
    var items = [
        [("Notes", "")],
        [("Send Message", ""), ("Share Contacts", ""), ("Add to Favourites", "")],
        [("Add to Emergency Contacts", "")],
        [("Share My Location", "")],
        [("Block this Caller", "")]
    ]
    
    var countSectionsWithInfo: Int!
    
    init(_ contact: ContactInfo) {
        let contactInfo = contact.getContactArr()
        countSectionsWithInfo = 0
        //items[0][0].1 = contact.notes
        for item in contactInfo.reversed() {
            if !item.isEmpty {
                items.insert(item, at: 0)
                countSectionsWithInfo += 1
            }
        }
    }
    
    func getItem(_ idxPath: IndexPath) -> (String, String) {
        return items[idxPath.section][idxPath.row]
    }
    
    func numRowsInSection(_ section: Int) -> Int {
        return items[section].count
    }
    
    func numSections() -> Int {
        return items.count
    }
}
