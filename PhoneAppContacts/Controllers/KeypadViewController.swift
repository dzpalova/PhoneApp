
import UIKit

class KeypadViewController: UIViewController {
    @IBOutlet private var numberLabel: UILabel!
    @IBOutlet private var addNumberButton: UIButton!
    @IBOutlet private var callButton: UIButton!
    @IBOutlet private var deleteButton: UIButton!
    private var keypadButtons: KeypadControl!
    
    private var addNewContactButton: UIButton!

    private let customGreenColor = UIColor(hex: "#00CD46")
    private let customGrayColor = UIColor(hex: "#E0E0E0")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteButton.addTarget(self, action: #selector(pressedBack), for: .touchUpInside)
        makeButtonRounded(callButton)
        
        let keypadFrame = CGRect(x: view.frame.minX + 40 , y: addNumberButton.frame.maxY + 60,
                                 width: view.frame.width - 80, height: view.frame.height - addNumberButton.frame.maxY + 10 - 300)
        keypadButtons = KeypadControl(frame: keypadFrame, style: .basicKeypad)
        keypadButtons.addTarget(self, action: #selector(buttonPressed), for: .valueChanged)
        keypadButtons.isHidden = false
        view.addSubview(keypadButtons)
    }
    
    @objc func buttonPressed(_ sender: KeypadControl) {
        numberLabel.text!.append(sender.pressedButton!)
        let num = numberLabel.text!
        if num.count == 1 {
            toggleDisappearingButtons()
        } else if (num.count == 3 || num.count == 7 && num.first! == "0") ||
                    (num.count == 3 && num.first! != "0" && num.first! != "+") {
            numberLabel.text?.append(" ")
        }
    }
    
    private func makeButtonRounded(_ button: UIButton) {
        button.layer.cornerRadius = 0.5 * button.frame.height
        button.clipsToBounds = true
    }
    
    private func toggleAddButtonAppearance() {
        let title = addNumberButton.isEnabled ? "" : "Add Number"
        addNumberButton.setTitle(title, for: .normal)
        addNumberButton.isEnabled.toggle()
    }
    
    private func toggleDeleteButtonAppearance() {
        deleteButton.isHidden.toggle()
        deleteButton.isEnabled.toggle()
    }
    
    private func toggleDisappearingButtons() {
        toggleAddButtonAppearance()
        toggleDeleteButtonAppearance()
    }
    
    private func changeGrayColorForSec(_ button: UIButton) {
        UIView.animate(withDuration: 1) {
            button.backgroundColor = .darkGray
            button.backgroundColor = self.customGrayColor
        }
    }

    @objc func pressedBack(_ sender: UIButton) {
        if !numberLabel.text!.isEmpty {
            numberLabel.text!.removeLast()
            if numberLabel.text!.isEmpty {
                toggleDisappearingButtons()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "startConversation" {
            let conversationViewController = segue.destination as! ConversationViewController
            conversationViewController.modalPresentationStyle = .overFullScreen
            conversationViewController.number = numberLabel.text
        }
    }

    @IBAction  func addNumber(_ sender: UIButton) {
    }
    
}
    

