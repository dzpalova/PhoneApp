//
//  FavouritesStore.swift
//  PhoneApp
//
//  Created by Daniela Palova on 11.06.21.
//

import CoreData

class FavouritesStore {
    static var shared = FavouritesStore()
    var favourites = [Favorite]()
    
    init() {
        loadData()
    }
    
    private func loadData() {
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        
        do {
            favourites = try AllContactsStore.viewContext.fetch(request)
        } catch {
            print("Error loading favourites",error)
        }
//        if favourites.isEmpty {
//            print("hereee")
//            let new = Favorite(context: AllContactsStore.viewContext)
//            new.contact = AllContactsStore.shared.getContact(IndexPath(row: 0, section: 0))
//            new.number = "088 4346631"
//            new.typeCall = "mobile"
//            favourites.append(new)
//        }
//        
        //favourites.forEach { AllContactsStore.viewContext.delete($0)}
        
        do {
            try AllContactsStore.viewContext.save()
        } catch {
            print("Error saving to Core Data", error)
        }
        
        // TO DO: numbers without contact
        favourites.sort { $0.contact!.getFullName() < $1.contact!.getFullName()}
    }
}
