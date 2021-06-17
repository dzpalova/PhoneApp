import UIKit

extension UIColor {
    convenience init?(hex: String) {
        if hex.first != "#" || hex.count != 7 && hex.count != 9 {
            return nil
        }
        guard let valueR = Int(hex.prefix(3).suffix(2), radix: 16),
              let valueG = Int(hex.prefix(5).suffix(2), radix: 16),
              let valueB = Int(hex.prefix(7).suffix(2), radix: 16) else {
            return nil
        }

        let redVal = CGFloat(valueR)
        let greenVal = CGFloat(valueG)
        let blueVal = CGFloat(valueB)
        var alphaVal: CGFloat = 255
        if hex.count == 9 {
            if let valueA = Int(hex.prefix(3).suffix(2), radix: 16) {
                alphaVal = CGFloat(valueA)
            }
        }
        self.init(red: redVal / 255, green: greenVal / 255, blue: blueVal / 255, alpha: alphaVal / 255)
    }
    
    static let customGreenColor = UIColor(hex: "#00CD46")
    static let customGrayColor = UIColor(hex: "#E0E0E0")
}

enum KeypadStyle {
    case keypadFromContacts
    case basicKeypad
}

class KeypadControl: UIControl {
    var pressedButton: String!
    
    private var sizeButton: CGFloat!
    
    private var numbersSource: KeypadNumbersSource!
    private var collectionViewButtons: UICollectionView!
    
    var longPressZeroFlag = true
    
    var style: KeypadStyle!
    
    @objc func longPressedZero() {
        longPressZeroFlag.toggle()
        
        if longPressZeroFlag {
            return
        }
        
        pressedButton = "+"
        sendActions(for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setAllButtons()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, style: KeypadStyle) {
        self.init(frame: frame)
        self.style = style
        setAllButtons()
    }
    
    func setAllButtons() {
        sizeButton = bounds.width / 3 - 20
        let buttonsTextColor: UIColor = (style == KeypadStyle.basicKeypad) ? .black : .white
        numbersSource = KeypadNumbersSource(cellSize: sizeButton, textColor: buttonsTextColor)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: sizeButton, height: sizeButton)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        collectionViewButtons = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionViewButtons.translatesAutoresizingMaskIntoConstraints = false
        collectionViewButtons.backgroundColor = .clear
        collectionViewButtons.register(NumberCollectionViewCell.self, forCellWithReuseIdentifier: "NumberCollectionViewCell")
        
        if style == .basicKeypad {
            numbersSource.numbers.forEach {
                if $0.titleLabel?.text == "0" {
                    let gestureRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(longPressedZero))
                    $0.addGestureRecognizer(gestureRecogniser)
                }
                $0.addTarget(self, action: #selector(pressedNumber), for: .touchUpInside)
            }
        } else {
            numbersSource.numbers.forEach {
                $0.addTarget(self, action: #selector(pressedNumber), for: .touchUpInside)
            }
        }
        
        addSubview(collectionViewButtons)
        collectionViewButtons.dataSource = numbersSource
    }
    
    private func changeGrayColorForSec(_ num: String) {
        UIView.animate(withDuration: 1) {
            self.numbersSource.backgroundButtonViews[num]?.backgroundColor = .darkGray
            self.numbersSource.backgroundButtonViews[num]?.backgroundColor = UIColor.customGrayColor
        }
    }
    
    private func changeGrayColorForSec(_ button: UIButton) {
        UIView.animate(withDuration: 1) {
            button.backgroundColor = .darkGray
            button.backgroundColor = UIColor.customGrayColor
        }
    }
    
    @objc func pressedNumber(_ sender: UIButton) {
        let newChar = sender.titleLabel!.text!
        
        if newChar == "*" || newChar == "#" {
            changeGrayColorForSec(sender)
        } else {
            changeGrayColorForSec(newChar)
        }
        
        pressedButton = newChar        
        sendActions(for: .valueChanged)
    }
}
