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
    @IBOutlet var buttons: [UIButton]!
    
    var items: ContactStore!
    var contact: Contact!
    var contactInfo: ContactInfo!
    
    var recentCalls: [RecentCall]!
    
    var numberToCall: String!
    
    private func updateContact() {
        contactPhoto = UIImageView(image: UIImage(named: contact.photoName ?? " "))
        contactName.text = contact.getFullName()
        
        contactInfo = contact.getContactInfo()
        items = ContactStore(contactInfo)
        
        if recentCalls != nil {
            items.items.insert(([("", "")]), at: 0)
        }
    }

    private func customizeNavigationBar() {
        let nbWidth = navigationController!.navigationBar.frame.width
        let photoSize = 100
        
        let contactView = UIView(frame: CGRect(x: 0, y: 60, width: nbWidth, height: 200))
        let photo = UIImageView(frame: CGRect(x: Int(nbWidth)/2 - photoSize/2, y: 100,
                                              width: photoSize, height: photoSize))
        contactView.backgroundColor = .red
        photo.image = UIImage(systemName: "person.crop.circle.fill")
        contactView.addSubview(photo)
        let height = CGFloat(400)

        navigationItem.largeTitleDisplayMode = .always
        navigationItem.titleView = contactView
//        navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: height)
//        navigationController?.navigationBar.insertSubview(contactView, belowSubview: navigationController!.navigationBar.superview!)
    }
    
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if tableView.contentOffset.y == -tableView.safeAreaInsets.top {
//
//            let nbWidth = navigationController!.navigationBar.frame.width
//            let photoSize = 100
//
//            let contactView = UIView(frame: CGRect(x: 0, y: 60, width: nbWidth, height: 200))
//            let photo = UIImageView(frame: CGRect(x: Int(nbWidth)/2 - photoSize/2, y: 100,
//                                                  width: photoSize, height: photoSize))
//            photo.image = UIImage(systemName: "person.crop.circle.fill")
//            contactView.addSubview(photo)
//
//            let height = CGFloat(400)
//            navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: height)
//            navigationController?.navigationBar.insertSubview(contactView, belowSubview: navigationController!.navigationBar.superview!)
//
//            //self.reloadInputViews()
//        } else {
//            let nbWidth = navigationController!.navigationBar.frame.width
//            let photoSize = 20
//
//            let contactView = UIView(frame: CGRect(x: 0, y: 60, width: nbWidth, height: 60))
//            let photo = UIImageView(frame: CGRect(x: Int(nbWidth)/2 - photoSize/2, y: 0,
//                                                  width: photoSize, height: photoSize))
//            photo.image = UIImage(systemName: "person.crop.circle.fill")
//            contactView.addSubview(photo)
//
//            let height = CGFloat(60)
//            navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: height)
//            navigationController?.navigationBar.insertSubview(contactView, belowSubview: navigationController!.navigationBar.superview!)
//            //self.reloadInputViews()
//        }
//    }
    override func viewDidLayoutSubviews() {
        //customizeNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //customizeNavigationBar()
        updateContact()
        createButtonMenus()
    }

    override func viewDidAppear(_ animated: Bool) {
        updateContact()
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.numRowsInSection(section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if recentCalls != nil && indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "recentCallsCell") as! RecentCallsCell
            cell.setup(recentCalls)
            return cell
        }
        
        let item = items.getItem(indexPath)
        
        var identifier = indexPath.section <= items.countSectionsWithInfo ? "typeValueCell" : "itemCell"
        if item.0 == "Notes" {
            identifier = "notesCell"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)!
        if let typeValueCell = cell as? TypeValueCell {
            if recentCalls != nil {
                let recent = recentCalls.first(where: { $0.number == item.1 })
                typeValueCell.isMissed = recent != nil && recent?.isMissed == true
                typeValueCell.isRecent = (recent != nil)
            }
            typeValueCell.isFavourite = FavouritesStore.shared.favourites.contains(where: { $0.number == item.1 } )
        }
        if let contactCell = cell as? ContactCell {
            contactCell.setup(item)
            return contactCell
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && !contactInfo.number.isEmpty {
            performSegue(withIdentifier: "callFromContact", sender: self)
        } else if indexPath.section == items.numSections() - 6 && indexPath.row == 2 { // Cell Add to favourites
            performSegue(withIdentifier: "showAddToFavouritesAlertController", sender: self)
        } else if indexPath.section == items.numSections() - 1 { //Outcoming Call
            RecentsStore.shared.createRecentCall(contact: contact, number: contactInfo.number.first!.value, type: "mobile", date: Date(), isMissed: false, isOutcome: true, timeInSeconds: 33)
        } else if indexPath.section == items.numSections() - 2 { //Missed Call
            RecentsStore.shared.createRecentCall(contact: contact, number: contactInfo.number.first!.value, type: "mobile", date: Date(), isMissed: true, isOutcome: true, timeInSeconds: 0)
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
            convController.number = numberToCall ?? items.getItem(tableView.indexPathForSelectedRow!).1
        case "showAddToFavouritesAlertController":
            let alertController = segue.destination as! AddToFavouritesController
            alertController.contact = contact
            alertController.contactInfo = contactInfo
        default:
            break
        }
    }
    
    func createButtonMenus() {
        var messageActions = [UIAction]()
        var callActions = [UIAction]()
        var emailActions = [UIAction]()
        
        contactInfo.number.forEach { num in
            let callAction = UIAction(title: num.type, image: UIImage(systemName: "phone"), handler: { _ in
                self.numberToCall = num.value
                self.performSegue(withIdentifier: "callFromContact", sender: self)
            })
            callAction.discoverabilityTitle = num.value
            callActions.append(callAction)
            
            let messageAction = UIAction(title: num.type, image: UIImage(systemName: "message"), handler: { _ in })
            messageAction.discoverabilityTitle = num.value
            messageActions.append(messageAction)
        }
        
        contactInfo.email?.forEach { email in
            let emailAction = UIAction(title: email.type, image: UIImage(systemName: "envelope"), handler: { _ in })
            emailAction.discoverabilityTitle = email.value
            emailActions.append(emailAction)
        }
        
        buttons.forEach { $0.showsMenuAsPrimaryAction = true }
        buttons[0].menu = UIMenu(children: callActions)
        buttons[1].menu = UIMenu(children: messageActions)
        buttons[3].menu = UIMenu(children: emailActions)
    }
}
