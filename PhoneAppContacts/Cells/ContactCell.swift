//
//  ContactCell.swift
//  RecentCalls
//
//  Created by Daniela Palova on 31.05.21.
//

import UIKit

extension UIStackView {
    func removeAllArrangedSubviews() {
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
//        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}

protocol ContactCell: UITableViewCell {
    func setup(_ item: (String,String))
}

class TypeValueCell: UITableViewCell, ContactCell {
    @IBOutlet var name: UILabel!
    @IBOutlet var number: UILabel!
    @IBOutlet var isRecentLabel: UILabel!
    @IBOutlet var isFavouriteImage: UIImageView!
    @IBOutlet var favouriteToRecentConstraint: NSLayoutConstraint!
    
    var isMissed = false
    var isFavourite = false
    
    func setup(_ item: (String, String)) {
        name.text = item.0
        number.text = item.1
        //name.textColor = isMissed ? .red : .black
        
        number.textColor = isMissed ? .red : .link
        
        isFavouriteImage.isHidden = !isFavourite
        favouriteToRecentConstraint.constant = isFavourite ? 5 : -isFavouriteImage.bounds.width
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
    
    private func formateDate(_ date: Date) -> String {
        let oneWeekTime: Double = -60 * 60 * 24 * 7
        
        if Calendar.current.isDateInToday(date) {
            return "Today"
        } else if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        } else if Date(timeIntervalSinceNow: oneWeekTime) < date {
            return RecentCallCell.fullDateFormatter.string(from: date)
        } else {
            return RecentCallCell.mediumDateFormatter.string(from: date)
        }
    }
    
    private func customizeItem(_ call: RecentCall) -> NSMutableAttributedString {
        let item = RecentCallCell.timeDateFormatter.string(from: call.date!)
        var type: String!
        if call.isMissed {
            type = "Missed"
        } else if call.isOutcome {
            type = "Incomming"
        } else {
            type = "Outgoing"
        }
        type += " Call"
        let endOfHour = item.firstIndex(of: " ")!
        let attribitedText = NSMutableAttributedString(string: item[...endOfHour] + " " + type)
        let hourRange = NSMakeRange(0, item[...endOfHour].count)
        attribitedText.addAttributes([NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 15)!], range: hourRange)
        return attribitedText
    }
    
    func setup(_ calls: [RecentCall]) {
        stackView.removeAllArrangedSubviews()
        day.text = formateDate(calls[0].date!)
        
        for call in calls {
            let callData = UILabel(frame: CGRect(x: 0, y: 0, width: stackView.layer.borderWidth, height: 20))
            callData.font = UIFont(name: "Helvetica-Bold", size: 13)!
            callData.attributedText = customizeItem(call)
            stackView.addArrangedSubview(callData)
            
            let convTime = call.timeInSeconds
            if convTime != 0 {
                let timeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: stackView.layer.borderWidth, height: 20))
                timeLabel.text = "            \(convTime) seconds"
                timeLabel.font = UIFont(name: "Helvetica Neue", size: 13)!
                timeLabel.textColor = .systemGray
                stackView.addArrangedSubview(timeLabel)
            }
            
            let emptyRow = UILabel(frame: CGRect(x: 0, y: 0, width: stackView.layer.borderWidth, height: 20))
            emptyRow.text = call == calls.last! ? "" : "  "
            stackView.addArrangedSubview(emptyRow)
        }
    }
}
