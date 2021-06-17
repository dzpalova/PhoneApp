//
//  TypeItemController.swift
//  RecentCalls
//
//  Created by Daniela Palova on 3.06.21.
//

import UIKit

class TypeItemController: UITableViewController {
    var types = ["home", "mobile", "work", "school", "iPhone", "Apple Watch",
                 "main", "home fax", "work fax", "pager", "other"]
    var selectedTypeIndex: Int!
    
    var cellButtonToChange: CustomCellButton!
    var oldButtonValue: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oldButtonValue = cellButtonToChange.titleLabel?.text
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return types.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        cell.textLabel?.text = types[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        selectedTypeIndex = selectedTypeIndex == indexPath.row ? -1 : indexPath.row
        let type = selectedTypeIndex == -1 ? "home" : types[selectedTypeIndex]
        cellButtonToChange.contactInfo.changeType(at: cellButtonToChange.indexOfCell, with: type)
        cellButtonToChange.setTitle(type, for: .normal)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView,
                            willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {
        cell.accessoryType = selectedTypeIndex == indexPath.row ? .checkmark : .none
    }

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        cellButtonToChange.setTitle(oldButtonValue, for: .normal)
        cellButtonToChange.contactInfo.changeType(at: cellButtonToChange.indexOfCell, with: oldButtonValue)
        dismiss(animated: true, completion: nil)
    }
}
