//
//  Contact.swift
//  RecentCalls
//
//  Created by Daniela Palova on 28.05.21.
//

import UIKit

class ContactController: UITableViewController {
    @IBOutlet var contactPhoto: UIImageView!
    @IBOutlet var contactName: UILabel!
    
    var items: ContactStore!
    var contact: Contact!
    var contactInfo: ContactInfo!
    
    var isSenderRecentCall = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateContact()
    }

    override func viewDidAppear(_ animated: Bool) {
        updateContact()
        tableView.reloadData()
    }
    
    private func updateContact() {
        contactPhoto = UIImageView(image: UIImage(named: contact.photoName ?? " "))
        contactName.text = contact.getFullName()
        
        contactInfo = contact.getContactInfo()
        items = ContactStore(contactInfo)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.numRowsInSection(section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items.getItem(indexPath)
        
        var identifier = indexPath.section <= items.countSectionsWithInfo ? "typeValueCell" : "itemCell"
        if item.0 == "Notes" {
            identifier = "notesCell"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)!
        if let contactCell = cell as? ContactCell {
//            if isSenderRecentCall {
//                let c = contact.recents?.first(where: { $0 as! RecentCall == contactInfo.number[indexPath.row]} ){
//                //contact.
//            }
            contactCell.setup(item)
            return contactCell
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && !contactInfo.number.isEmpty {
            performSegue(withIdentifier: "callFromContact", sender: self)
        } else if indexPath.section == items.numSections() - 4 && indexPath.row == 2 { // Cell Add to favourites
            performSegue(withIdentifier: "showAddToFavouritesAlertController", sender: self)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return items.numSections()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch segue.identifier {
        case "editContact":
            let navContr = segue.destination as! UINavigationController
            let contactController = navContr.topViewController as! EditContactController
            contactController.modalPresentationStyle = .fullScreen
            contactController.contact = contact
            contactController.contactInfo = contactInfo
            contactController.isModalPresentation = false
        case "callFromContact":
            let convController = segue.destination as! ConversationViewController
            convController.contactObject = contact
        case "showAddToFavouritesAlertController":
            let alertController = segue.destination as! AddToFavouritesController
            alertController.contact = contact
            alertController.contactInfo = contactInfo
        default:
            break
        }
    }
}
