import UIKit

class ConversationViewController: UIViewController {
    @IBOutlet var contact: UILabel!
    @IBOutlet var timer: UILabel!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var labels: [UILabel]!
    @IBOutlet var endConversationButton: UIButton!
    var contactName: String!
    var number: String!
    var contactObject: Contact!
    var recentCalls: [RecentCall]!
    
    var time = Timer()
    var seconds = 0
    var minutes = 0
    
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
        contactName = contactName ?? contactObject.getFullName()
        contact.text = contactName
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
        
        time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    func pad(_ n: Int) -> String {
        return n > 9 ? "\(n)" : "0\(n)"
    }
    
    @objc func updateTime() {
        if seconds == 60 {
            seconds = 0
            minutes += 1
        }
        
        timer.text = pad(minutes) + ":" + pad(seconds)
        seconds += 1
    }
    
    @IBAction func endConversation(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
        if contactName != nil && contactName.isEmpty {
            return
        }
        
        if callStore.callsCount() == 0 {
            let call = RecentsStore.shared.createRecentCall(contact: contactObject, number: number, type: "mobile", date: Date(), isMissed: false, isOutcome: false, timeInSeconds: minutes * 60 + seconds)
            callStore.allCalls.append([call])
            return
        }
        let lastCall = callStore.getCalls(at: IndexPath(row: 0, section: 0))
        let call = RecentsStore.shared.createRecentCall(contact: contactObject, number: number, type: "mobile", date: Date(), isMissed: false, isOutcome: false, timeInSeconds: minutes * 60 + seconds)
        if lastCall.first!.number != number || lastCall.first!.isMissed {
            callStore.allCalls.insert([call], at: 0)
        } else {
            callStore.allCalls[0].append(call)
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
