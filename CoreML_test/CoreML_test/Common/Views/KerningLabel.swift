//
//  KearningLabel.swift
//  CoreML_test
//
//  Created by Осина П.М. on 27.02.18.
//  Copyright © 2018 Осина П.М. All rights reserved.
//

import Foundation
import UIKit


class KerningLabel: UILabel {
    
    @IBInspectable
    var kern: CGFloat = 1 {
        didSet {
            updateText()
        }
    }
    
    override var text: String? {
        didSet {
            updateText()
        }
    }
    
    private func updateText() {
        var resultString: NSAttributedString?
        if let text = self.text {
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(NSAttributedStringKey.kern,
                                          value: kern,
                                          range: NSRange(location: 0, length: attributedString.length))
            resultString = attributedString
        }
        self.attributedText = resultString
    }
}


extension KerningLabel {
    
    class func createForNavigationTitle(withFontSize fontSize: CGFloat = 22, kern: CGFloat = 3.8) -> KerningLabel{
        let titleLabel = KerningLabel()
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.kern = kern
        titleLabel.textColor = .black
        titleLabel.font = UIFont(name: "SFUIDisplay-Regular", size: fontSize)
        return titleLabel
        
    }
    
}
