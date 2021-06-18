//
//  AddToFavouritesController.swift
//  PhoneApp
//
//  Created by Daniela Palova on 14.06.21.
//
import Foundation
import UIKit

class AddToFavouritesController: UIViewController ,UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var tableViewBackground: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var tableViewTopConstraint: NSLayoutConstraint!
    
    var contact: Contact!
    var contactInfo: ContactInfo!
    
    var openedSection: Int? = nil
    var rowHeight: CGFloat = 70
    
    var items: [(type: String, imageType: String, contactData: [(String, String)])] = [
        ("Message", "message.fill", []),
        ("Call", "phone.fill", []),
        ("Video", "video.fill", []),
        ("Mail", "envelope.fill", []),
    ]
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapGestureAction(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        contactInfo.number.forEach { items[0].contactData.append(($0.type, $0.value)) }
        if items[0].contactData.isEmpty {
            items.remove(at: 0)
        }
        contactInfo.number.forEach { items[1].contactData.append(($0.type, $0.value)) }
        if items[1].contactData.isEmpty {
            items.remove(at: 1)
        }
        contactInfo.email.forEach { items[3].contactData.append(($0.type, $0.value)) }
        if items[3].contactData.isEmpty {
            items.remove(at: 3)
        }
        //items[3].contactData.removeLast()
        items.remove(at: 2)
        
        tableViewTopConstraint.constant = view.frame.height - (CGFloat(items.count) * rowHeight) - 163
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = openedSection == nil ? items.count : items[openedSection!].contactData.count + 1
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if openedSection != nil && indexPath.row != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "alertTableCell2") as! AlertTableTypeValueCell
            let typeValue = items[openedSection!].contactData[indexPath.row - 1]
            cell.type.text = typeValue.0
            cell.value.text = typeValue.1
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "alertTableCell1") as! AlertTableTypeCell
        let item = openedSection != nil ? items[openedSection!] : items[indexPath.row]
        cell.type.text = item.type
        cell.typeImage.image = UIImage(systemName: item.imageType)
        cell.detailImage.image = UIImage(systemName: openedSection == nil ? "chevron.down" : "chevron.up")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    private func addToFavourites(_ item: (String, String)) {
        if FavouritesStore.shared.favourites.first(where: { $0.number == item.1 }) != nil {
            return
        }
        let newFavourite = Favorite(context: AllContactsStore.viewContext)
        newFavourite.contact = contact
        newFavourite.number = item.1
        newFavourite.typeCall = item.0
        
        do {
            try AllContactsStore.viewContext.save()
        } catch {
            print("Error saving to Core Data", error)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if openedSection != nil {
            if indexPath.row == 0 {
                openedSection = nil
                tableViewTopConstraint.constant = view.frame.height - (CGFloat(items.count) * rowHeight) - 163
                tableView.reloadData()
            } else {
                addToFavourites(items[openedSection!].contactData[indexPath.row - 1])
                dismiss(animated: true, completion: nil)
            }
        } else {
            openedSection = indexPath.row
            let rows = items[indexPath.row].contactData.count + 1
            tableViewTopConstraint.constant = view.frame.height - (CGFloat(rows) * rowHeight) - 163
            tableView.reloadData()
        }
    }
}
