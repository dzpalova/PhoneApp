//
//  EditContactCell.swift
//  RecentCalls
//
//  Created by Daniela Palova on 31.05.21.
//

import UIKit

protocol LabeledCell {
    func setCell(_ item: EditContactItem)
}

protocol EditCell {
    var indexOfCell: IndexPath! { get set }
    var contactInfo: ContactInfo! { get set }
}

class TextFieldCell: UITableViewCell, LabeledCell, EditCell {
    @IBOutlet var field: UITextField!
    var indexOfCell: IndexPath!
    var contactInfo: ContactInfo!
    
    func setCell(_ item: EditContactItem) {
        field.placeholder = item.name
        field.text = item.name == "Notes" ? item.name : item.detail
        field.contentVerticalAlignment = item.name == "Notes" ? .top : .center
        
        field.addTarget(self, action: #selector(cellDataChanged), for: .editingChanged)
        
        if field.placeholder == "First name" && field.text!.isEmpty {
            field.becomeFirstResponder()
        }
    }
    
    @objc func cellDataChanged() {
        EditContactController.editedContact[indexOfCell.row] = field.text!
    }
}

class AddItemCell: UITableViewCell, LabeledCell {
    @IBOutlet var name: UILabel!
    
    func setCell(_ item: EditContactItem) {
        name.text = item.name
    }
}

class DetailCell: UITableViewCell, LabeledCell {
    @IBOutlet var name: UILabel!
    @IBOutlet var detail: UILabel!
    
    func setCell(_ item: EditContactItem) {
        name.text = item.name
        detail.text = item.detail
    }
}

class TextCell: UITableViewCell, LabeledCell {
    @IBOutlet var name: UILabel!
 
    func setCell(_ item: EditContactItem) {
        name.text = item.name
        
        let col: UIColor
        switch item.name {
        case "add field":
            col = .systemBlue
        case "Delete Contact":
            col = .red
        default:
            col = .black
        }
        
        name.textColor = col
    }
}

class NotesEditCell: UITableViewCell, LabeledCell {
    @IBOutlet var notes: UITextField!
    
    func setCell(_ item: EditContactItem) {
        notes.text = item.detail
    }
}

class RemoveItemcell: UITableViewCell, LabeledCell, EditCell {
    @IBOutlet var type: CustomCellButton!
    @IBOutlet var value: UITextField!
    @IBOutlet var gradientLine: UIView!
    
    var indexOfCell: IndexPath!
    var contactInfo: ContactInfo!

    func setCell(_ contact: EditContactItem) {
        type.setTitle(contact.name, for: .normal)
        let isValueReal = TypeSectionStr.allCases.firstIndex { $0.rawValue == contact.detail }
        value.text = ""
        if isValueReal == nil {
            value.text = contact.detail
        } else {
            value.placeholder = contact.detail
        }
        value.addTarget(self, action: #selector(cellDataChanged), for: .editingChanged)
        setLine()
        
        type.indexOfCell = indexOfCell
        type.contactInfo = contactInfo
        
        if value.text!.isEmpty {
            value.becomeFirstResponder()
        }
    }
    
    private func setLine() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.white.cgColor, UIColor.systemGray2.cgColor]
        gradient.frame = CGRect(x: 0, y: 0, width: 1, height: gradientLine.bounds.height + 10)
        gradientLine.layer.addSublayer(gradient)
    }
    
    @objc func cellDataChanged() {
        let typeValue = TypeValue(type: type.titleLabel?.text, value: value.text)
        contactInfo.changeInfo(at: indexOfCell, with: typeValue)
    }
}

class RemoveDateCell: UITableViewCell, LabeledCell, EditCell {
    @IBOutlet var type: CustomCellButton!
    @IBOutlet var date: UIButton!
    @IBOutlet var gradientLine: UIView!
    
    var indexOfCell: IndexPath!
    var contactInfo: ContactInfo!
    
    func setCell(_ contact: EditContactItem) {
        type.setTitle(contact.name, for: .normal)
        date.setTitle(contact.detail, for: .normal)
        
        type.addTarget(self, action: #selector(cellDataChanged), for: .valueChanged)
        date.addTarget(self, action: #selector(cellDataChanged), for: .valueChanged)
        
        type.contactInfo = contactInfo
        type.indexOfCell = indexOfCell
        
        setLine()
    }
    
    private func setLine() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.white.cgColor, UIColor.systemGray4.cgColor]
        gradient.frame = CGRect(x: 0, y: 0, width: 1, height: gradientLine.bounds.height + 10)
        gradientLine.layer.addSublayer(gradient)
    }
    
    @objc func cellDataChanged() {
        let typeValue = TypeValue(type: type.titleLabel?.text, value: date.titleLabel?.text)
        contactInfo.changeInfo(at: indexOfCell, with: typeValue)
    }
}

class RemoveAddressCell: UITableViewCell, EditCell {
    @IBOutlet var type: CustomCellButton!
    @IBOutlet var street: UITextField!
    @IBOutlet var city: UITextField!
    @IBOutlet var state: UITextField!
    @IBOutlet var ZIP: UITextField!
    @IBOutlet var country: UIButton!
    @IBOutlet var grLines: [UIView]!
    
    var indexOfCell: IndexPath!
    var contactInfo: ContactInfo!
    
    func setCell(_ contact: TypeValue<Address>) {
        type.setTitle(contact.type, for: .normal)
        street.text = contact.value.street
        city.text = contact.value.city
        state.text = contact.value.state
        ZIP.text = contact.value.ZIP
        country.setTitle(contact.value.country, for: .normal)
        
        street.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        city.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        state.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        ZIP.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        type.contactInfo = contactInfo
        type.indexOfCell = indexOfCell
        
        setLine()
        
        if [street, city, state, ZIP].allSatisfy { $0!.text!.isEmpty } {
            street.becomeFirstResponder()
        }
    }
    
    private func setLine() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.white.cgColor, UIColor.systemGray2.cgColor]
        gradient.frame = CGRect(x: 0, y: 0, width: 1, height: grLines.first!.bounds.height + 10)
        grLines.forEach { $0.layer.addSublayer(gradient) }
    }
    
    @objc func textFieldChanged() {
        let typeValue = TypeValue<Address>(type: type.titleLabel?.text, value: Address(street: street.text, city: city.text, state: state.text, ZIP: ZIP.text, country: country.titleLabel?.text))
        contactInfo.changeAddress(at: indexOfCell, with: typeValue)
    }
}
