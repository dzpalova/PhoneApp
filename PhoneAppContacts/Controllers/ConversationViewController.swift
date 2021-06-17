import UIKit

class ConversationViewController: UIViewController {
    @IBOutlet var contact: UILabel!
    @IBOutlet var timer: UILabel!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var labels: [UILabel]!
    @IBOutlet var endConversationButton: UIButton!
    var number: String!
    var contactObject: Contact!
    var recentCalls: [RecentCall]!
    
    let callStore = SceneDelegate.recentCallStore
    
    private var keypadButtons: KeypadControl!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var hideButton: UIButton!
    
    private let customGrayColor = UIColor(hex: "#E0E0E0")
    
    private func makeButtonRounded(_ button: UIButton) {
        button.layer.cornerRadius = 0.5 * button.frame.height
        button.clipsToBounds = true
    }
    
    @IBAction private func changeView() {
        buttons.forEach { $0.isHidden.toggle() }
        labels.forEach { $0.isHidden.toggle() }
        timer.isHidden.toggle()
        contact.isHidden.toggle()
        keypadButtons.isHidden.toggle()
        numberLabel.isHidden.toggle()
        hideButton.isHidden.toggle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        number = number ?? contactObject.getFullName()
        contact.text = number
        buttons.forEach {
            makeButtonRounded($0)
        }
        
        let keypadFrame = CGRect(x: view.frame.minX + 40 , y: numberLabel.frame.maxY + 100, width: view.frame.width - 80, height: view.frame.width)
        keypadButtons = KeypadControl(frame: keypadFrame, style: .keypadFromContacts)
        keypadButtons.addTarget(self, action: #selector(buttonPressed), for: .valueChanged)
        keypadButtons.isHidden = true
        view.addSubview(keypadButtons)
        
        numberLabel.isHidden = true
        hideButton.isHidden = true
        makeButtonRounded(endConversationButton)
    }
    
    private func createRecentCall(contact: Contact?, fullName: String, numCalls: Int64, type: String, date: Date, isMissed: Bool, isOutgoing: Bool) -> RecentCall {
        let newCall = RecentCall(context: AllContactsStore.viewContext)
        newCall.contact = contact
        newCall.date = date
        newCall.type = type
        newCall.isMissed = isMissed
        newCall.isOutcome = isOutgoing
        newCall.numCalls = numCalls
        newCall.fullName = fullName
        
        do {
            try AllContactsStore.viewContext.save()
        } catch {
            print("Error saving to Core Data", error)
        }
        
        return newCall
    }
    
    @IBAction func endConversation(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
        if number != nil && number.isEmpty {
            return 
        }
        
        if callStore.callsCount() == 0 {
            let call = createRecentCall(contact: contactObject, fullName: number, numCalls: 1, type: "mobile", date: Date(), isMissed: false, isOutgoing: true)
            callStore.allCalls.append(call)
            return
        }
        let lastCall = callStore.getCall(at: IndexPath(row: 0, section: 0))
        if lastCall.fullName != number || lastCall.isMissed {
            let call = createRecentCall(contact: contactObject, fullName: number, numCalls: 1, type: "mobile", date: Date(), isMissed: false, isOutgoing: true)
            callStore.allCalls.insert(call, at: 0)
        } else {
            callStore.allCalls[0].numCalls += 1
            callStore.allCalls[0].saveData()
        }
    }
    
    @objc func buttonPressed(_ sender: KeypadControl) {
        numberLabel.text?.append(sender.pressedButton!)
        let num = numberLabel.text!
        if (num.count == 3 || num.count == 7 && num.first! == "0") ||
                    (num.count == 3 && num.first! != "0" && num.first! != "+") {
            numberLabel.text?.append(" ")
        }
    }
}
