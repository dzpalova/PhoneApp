import UIKit
import CoreData

class ContactsViewController: UITableViewController, UISearchBarDelegate {
    var allContactItems: AllContactsStore!
    var contactItems: AllContactsStore!
    
    @IBOutlet var userCardView: UIView!
    var searchBar: UISearchController!
    
    override func viewDidLoad() {
        allContactItems = AllContactsStore()
        contactItems = allContactItems
        
        title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        searchBar = UISearchController()
        navigationItem.searchController = searchBar
        searchBar.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        allContactItems = AllContactsStore()
        contactItems = allContactItems
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            tableView.reloadData()
        }

        var filtered = [Contact]()
        for contact in allContactItems {
            if (contact.firstName ?? "").prefix(searchText.count).lowercased() == searchText.lowercased() {
                filtered.append(contact)
            }
        }
        
        if filtered.count != 0 {
            contactItems.clearAll()
            contactItems.parseData(filtered)
        } else {
            contactItems = allContactItems
        }
        tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        contactItems = allContactItems
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactItems.rowsInSection(section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactItem", for: indexPath)
        let contact = contactItems.getContact(indexPath)
        cell.textLabel?.text = (contact.firstName ?? "") + " " + (contact.lastName ?? "")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        contactItems.titleSection(section)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return contactItems.numSections
    }

    private func createEmptyContact() -> Contact {
        let newContact = Contact(context: AllContactsStore.viewContext)
        
        let contactInfo = """
            {
                "number": [],
                "email": [],
                "ringtone": "Default",
                "textTone": "Default",
                "url": [],
                "address": [],
                "birthday": [],
                "date": [],
                "relatedName": [],
                "socialProfile": [],
                "instantMessage": [],
            }
        """
        newContact.otherInformation = contactInfo
        let cI = newContact.getContactInfo()
        newContact.saveEditedItem(contactInfo: cI)
        return newContact
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier {
        case "showContactInfo":
            let contactController = segue.destination as! ContactController
            contactController.modalPresentationStyle = .overFullScreen
            contactController.contact = contactItems.getContact(tableView.indexPathForSelectedRow!)
        case "createNewContact":
            let navControler = segue.destination as! UINavigationController
            let contactController = navControler.topViewController as! EditContactController
            let newContact = createEmptyContact()
            contactController.contact = newContact
            contactController.contactInfo = newContact.getContactInfo()
            contactController.isModalPresentation = true
        default:
            break
        }
    }
}
