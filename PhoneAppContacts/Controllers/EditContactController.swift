//
//  EditContactController.swift
//  RecentCalls
//
//  Created by Daniela Palova on 31.05.21.
//

import UIKit
import CoreData

enum TypeSectionStr: String, CaseIterable {
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

class EditContactController: UITableViewController {
    var editItems: EditContactStore!
    var contact: Contact!
    var contactInfo: ContactInfo!
    static var editedContact: [String?]!    
    
    var isModalPresentation: Bool!

    let typePhoneLabels = ["home", "mobile", "work", "school", "iPhone", "Apple Watch",
                           "main", "home fax", "work fax", "pager", "other"]
    var typeItemLabelToInsert = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        editItems = EditContactStore(contact: contact, contactInfo: contactInfo)
        Self.editedContact = Array(repeating: nil, count: 5)
        
        setEditing(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let tabBar = presentingViewController as? UITabBarController,
           let navVC = tabBar.selectedViewController as? UINavigationController,
           let contactsVC = navVC.topViewController as? ContactsViewController {
            DispatchQueue.main.async {
                contactsVC.allContactItems = AllContactsStore()
                contactsVC.contactItems = contactsVC.allContactItems
                contactsVC.tableView.reloadData()
            }
        }
    }
    
    private func updateContact() {
        contact.firstName = Self.editedContact[0] ?? contact.firstName
        contact.lastName = Self.editedContact[1] ?? contact.lastName
        contact.company = Self.editedContact[2] ?? contact.company
    }
    
    @IBAction func doneEditing(_ sender: UIBarButtonItem) {
        updateContact()
        contact.saveEditedItem(contactInfo: contactInfo)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelEditing(_ sender: UIBarButtonItem) {
        let actionController = UIAlertController(title: nil, message: "Are you sure you want to discard your changes?", preferredStyle: .actionSheet)
        
        let discardChanges = UIAlertAction(title: "Discard changes", style: .destructive) {_ in
            if self.isModalPresentation {
                self.contact.delete()
            }
            self.dismiss(animated: true, completion: nil)
        }
        let keepEditing = UIAlertAction(title: "Keep editing", style: .cancel, handler: nil)
        
        actionController.addAction(discardChanges)
        actionController.addAction(keepEditing)
        
        present(actionController, animated: false, completion: nil)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!

        if indexPath.section == TypeSection.address.rawValue && indexPath.row < contactInfo.address.count {
            cell = tableView.dequeueReusableCell(withIdentifier: "removeAddress")!
            if let labeledCell = cell as? RemoveAddressCell {
                if var c = cell as? EditCell {
                    c.indexOfCell = indexPath
                    c.contactInfo = contactInfo
                }
                labeledCell.setCell(contactInfo.address[indexPath.row])
            }
        } else {
            let item = editItems.getItem(at: indexPath)
            cell = tableView.dequeueReusableCell(withIdentifier: item.type.rawValue)!
            if let labeledCell = cell as? LabeledCell {
                if var c = cell as? EditCell {
                    c.indexOfCell = indexPath
                    c.contactInfo = contactInfo
                }
                labeledCell.setCell(item)
            }
        }
        
        //c.value.becomeFirstResponder()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return indexPath.row + 1 < editItems.numRowsInSection(indexPath.section) ? .delete : .insert
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return ![0, 3, 4, 12, 13, 14, 15].contains(indexPath.section)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            editItems.items[indexPath.section].remove(at: indexPath.row)
            contactInfo.removeItem(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } else if editingStyle == .insert {
            let detail = TypeSectionStr.allCases[indexPath.section]
            
            var typeCell: EditContactItemType = detail == .address ? .removeAddress : .removeItem
            typeCell = detail == .date || detail == .birthday ? .removeDate : typeCell
            
            let typeItem = typePhoneLabels[typeItemLabelToInsert]
            
//            if detail == .address {
//                contactInfo.address.append(TypeValue(type: typeItem, value: Address(street: "", city: "", state: "", ZIP: "", country: "")))
//            } else {
                contactInfo.insertItem(item: TypeValue(type: typeItem, value: ""), at: indexPath)
//            }
                editItems.items[indexPath.section].insert(EditContactItem(name: typeItem, type: typeCell, detail: detail.rawValue),
                                                      at: editItems.numRowsInSection(indexPath.section) - 1)
            typeItemLabelToInsert = typeItemLabelToInsert == typePhoneLabels.count ? 0 : typeItemLabelToInsert + 1
            tableView.insertRows(at: [indexPath], with: .none)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == editItems.numSections - 1 {
            let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: "Delete Contact", style: .destructive) {_ in
                self.contact.delete()
                self.performSegue(withIdentifier: "fromEditToContacts", sender: Self.self)
                //self.dismiss(animated: true)
                //(self.presentingViewController as? UINavigationController)?.popToRootViewController(animated: true)
            }
            
            controller.addAction(cancelAction)
            controller.addAction(deleteAction)
            present(controller, animated: false, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return editItems.numRowsInSection(section)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return editItems.numSections
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 6 {
            if indexPath.row == contactInfo.address.count {
                return 44
            }
            return 42 * 4
        } else if indexPath.section == 12 {
            return 120
        }
        return 44
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == editItems.numSections - 2 {
            return "LINKED CONTACTS"
        }
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if ["pickItemType", "pickAddressType", "pickDateType"].contains(segue.identifier) {
            let navContr = segue.destination as! UINavigationController
            let contr = navContr.topViewController as! TypeItemController
            let button = sender as! CustomCellButton
            contr.cellButtonToChange = button
        }
    }
}
