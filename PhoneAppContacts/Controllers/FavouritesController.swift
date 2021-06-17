//
//  FavouritesController.swift
//  Phone
//
//  Created by Daniela Palova on 10.06.21.
//

import UIKit

class FavouritesController: UITableViewController {
    var favouritesStore = FavouritesStore.shared
    
    var contactToOpen: Contact!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favourites"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favouritesStore = FavouritesStore()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if favouritesStore.favourites.count == 0 {
            return UITableViewCell()
        }
        let favourite = favouritesStore.favourites[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "favouriteCell") as! FavouriteCell
        cell.setup(favourite)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouritesStore.favourites.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            AllContactsStore.viewContext.delete(favouritesStore.favourites[indexPath.row])
            do {
                try AllContactsStore.viewContext.save()
            } catch {}
            favouritesStore.favourites.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        contactToOpen = favouritesStore.favourites[indexPath.row].contact
        performSegue(withIdentifier: "showContactFromFavourites", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showContactFromFavourites" {
            let contactController = segue.destination as! ContactController
            contactController.contact = contactToOpen
        }
    }
}
