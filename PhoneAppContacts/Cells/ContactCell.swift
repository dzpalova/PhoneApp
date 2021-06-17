//
//  ContactCell.swift
//  RecentCalls
//
//  Created by Daniela Palova on 31.05.21.
//

import UIKit

protocol ContactCell: UITableViewCell {
    func setup(_ item: (String,String))
}

class TypeValueCell: UITableViewCell, ContactCell {
    @IBOutlet var name: UILabel!
    @IBOutlet var number: UILabel!
    
    var isMissed = false
    
    func setup(_ item: (String, String)) {
        name.text = item.0
        number.text = item.1
        name.textColor = isMissed ? .red : .black
    }
}

class ItemCell: UITableViewCell, ContactCell {
    @IBOutlet var name: UILabel!
    
    func setup(_ item: (String, String)) {
        name.text = item.0
        name.textColor = item.0.hasPrefix("Block") ? .red : .systemBlue
    }
}

class NotesCell: UITableViewCell, ContactCell {
    @IBOutlet var notes: UITextView!
    
    func setup(_ item: (String, String)) {
        notes.text = item.1
    }
}
