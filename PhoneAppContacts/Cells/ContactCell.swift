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

class RecentCallsCell: UITableViewCell {
    @IBOutlet var day: UILabel!
    @IBOutlet var stackView: UIStackView!
    
    let timeDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()

    let fullDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter
    }()
    
    func setup(_ calls: [RecentCall]) {
        day.text = RenectCallCell.formateDate(call: calls[0])
        
        for call in calls {
            let callData = UILabel(frame: CGRect(x: 0, y: 0, width: stackView.layer.borderWidth, height: 20))
            callData.text = timeDateFormatter.string(from: call.date!)
            stackView.addArrangedSubview(callData)
        }
    }
}
