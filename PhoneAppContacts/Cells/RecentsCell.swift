import UIKit

class RecentCallCell: UITableViewCell {
    @IBOutlet var isMissedIcon: UIImageView!
    @IBOutlet var contactNameLabel: UILabel!
    @IBOutlet var numberMissedCallsLabel: UILabel!
    @IBOutlet var typeCallLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    static let timeDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()
    
    static let mediumDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
    
    static let fullDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter
    }()
    
    
    private func formateDate(call: RecentCall) -> String {
        let oneWeekTime: Double = -60 * 60 * 24 * 7
        
        if Calendar.current.isDateInToday(call.date!) {
            return Self.timeDateFormatter.string(from: call.date!)
        } else if Calendar.current.isDateInYesterday(call.date!) {
            return "Yesterday"
        } else if Date(timeIntervalSinceNow: oneWeekTime) < call.date! {
            return Self.fullDateFormatter.string(from: call.date!)
        } else { 
            return Self.mediumDateFormatter.string(from: call.date!)
        }
    }
    
    func setCell(with calls: [RecentCall]) {
        contactNameLabel.text = calls.first!.contact?.getFullName()
        contactNameLabel.textColor = calls.first!.isMissed ? .red : .black

        numberMissedCallsLabel.text = calls.count > 1 ? "(\(calls.count))" : ""
        numberMissedCallsLabel.textColor = calls.first!.isMissed ? .red : .black
        
        typeCallLabel.text = calls.first!.type
        dateLabel.text = formateDate(call: calls.first!)
        isMissedIcon.isHidden = !calls.first!.isOutcome
    }
}
