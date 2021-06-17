import UIKit

class KeypadNumbersSource: NSObject, UICollectionViewDataSource {
    var numbers = [UIButton]()
    var backgroundButtonViews: [String: UIView] = [:]
    var textColor: UIColor!
    
    private let charsUnderNum: [String:String] = [
        "0": "+"   , "1": "" ,
        "2": "ABC" , "3": "DEF" ,
        "4": "GHI" , "5": "JKL" ,
        "6": "MNO" , "7": "PQRS",
        "8": "TUV" , "9": "WXYZ"
    ]
    
    init(cellSize: CGFloat, textColor: UIColor) {
        super.init()
        self.textColor = textColor
        let labels = ["1","2","3","4","5","6","7","8","9","*","0","#"]
        
        for label in labels {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: cellSize, height: cellSize))
            button.setTitle(label, for: .normal)
            button.titleLabel?.isHidden = false
            if charsUnderNum.keys.contains(label) {
                createbackgroundButtonView(button)
            } else {
                button.setTitleColor(textColor, for: .normal)
                makeButtonRounded(button)
                button.backgroundColor = UIColor.customGrayColor
            }
            numbers.append(button)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NumberCollectionViewCell",
                                                      for: indexPath) as! NumberCollectionViewCell
        cell.setNumberButton(to: numbers[indexPath.row])
        return cell
    }
    
    private func makeViewRounded(_ view: UIView) {
        view.layer.cornerRadius = 0.5 * view.frame.width
        view.clipsToBounds = true
    }
    
    private func makeButtonRounded(_ button: UIButton) {
        button.layer.cornerRadius = 0.5 * button.frame.height
        button.clipsToBounds = true
    }

    private func createLabel(_ rect: CGRect, _ text: String, _ size: CGFloat) -> UILabel {
        let label = UILabel(frame: rect)
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.textColor = textColor
        label.text = text
        label.font = UIFont(name: "Helvetica" , size: size)
        return label
    }
    
    private func createbackgroundButtonView(_ button: UIButton) {
        let buttonLabelsView = UIView(frame: button.frame)
        buttonLabelsView.backgroundColor = UIColor.customGrayColor
        makeViewRounded(buttonLabelsView)
        
        let buttonNum = button.titleLabel!.text!
        
        let labelNumFrame = CGRect(x: button.frame.minX,
                                   y: button.frame.minY + 2 / 9 * button.frame.width,
                                   width: button.frame.width,
                                   height: 4 / 9 * button.frame.width)
        let labelCharsFrame = CGRect(x: button.frame.minX ,
                                     y: button.frame.minY + 6 / 9 * button.frame.width,
                                     width: button.frame.width,
                                     height: 1 / 9 * button.frame.width)
        
        let labelNum = createLabel(labelNumFrame, buttonNum, 40)
        let labelChars = createLabel(labelCharsFrame, charsUnderNum[buttonNum]!, 10)
        
        buttonLabelsView.addSubview(labelChars)
        buttonLabelsView.addSubview(labelNum)
        button.addSubview(buttonLabelsView)
        buttonLabelsView.isUserInteractionEnabled = false

        backgroundButtonViews["\(buttonNum)"] = buttonLabelsView
    }
}

