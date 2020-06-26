//
//  ViewController.swift
//  LabelTap
//
//  Created by Jaganmohanarao Sambangi on 26/06/20.
//  Copyright © 2020 Quest. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tbl: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

extension ViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "LabelTableViewCell", for: indexPath) as! LabelTableViewCell
               cell.loadData()
              
               
               return cell
    }
    
    
}
class LabelTableViewCell: UITableViewCell {
    @IBOutlet weak var lbl: UILabel!
   
    func loadData()
    {
        self.lbl?.text = "Sorry! We are having trouble loading. Try again!"
        let text = self.lbl?.text!
        let underlineAttriString = NSMutableAttributedString(string: text ?? "")
        let termsRange = (text! as NSString).range(of: "Try again!")
        underlineAttriString.addAttribute(.foregroundColor, value: UIColor.blue, range: termsRange)
        self.lbl.attributedText = underlineAttriString
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(self.tapLabel(gesture:)))
        self.lbl.isUserInteractionEnabled = true
        self.lbl.addGestureRecognizer(tapAction)
    }
    
     @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
             if gesture.didTapAttributedTextInLabel(label: self.lbl, targetText: "Try again!") {
                 print("Try again!")
             }
              else {
                 print("none")
             }
     }
}


extension UITapGestureRecognizer {
    func didTapAttributedTextInLabel(label: UILabel, targetText: String) -> Bool {
        guard let attributedString = label.attributedText, let lblText = label.text else { return false }
        let targetRange = (lblText as NSString).range(of: targetText)
        //IMPORTANT label correct font for NSTextStorage needed
        let mutableAttribString = NSMutableAttributedString(attributedString: attributedString)
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = label.textAlignment
        mutableAttribString.addAttributes(
            [NSAttributedString.Key.font: label.font ?? UIFont.systemFont(ofSize: 18),NSAttributedString.Key.paragraphStyle:paragraph],
            range: NSRange(location: 0, length: attributedString.length)
        )
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: mutableAttribString)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y:
            locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
   print(indexOfCharacter)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }

}
