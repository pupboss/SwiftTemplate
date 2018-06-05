//
//  UILabel.swift
//  SwiftTemplate
//
//  Created by Jet Lee on 5/6/18.
//  Copyright © 2018 PUPBOSS. All rights reserved.
//

import UIKit

extension UILabel {
    func changeCharacterSpace(space: CGFloat) {
        text = text ?? ""
        let attributedString = NSMutableAttributedString(string: text!, attributes: [.kern: space])
        let paragraphStyle = NSMutableParagraphStyle()
        attributedString.addAttributes([.paragraphStyle: paragraphStyle], range: NSMakeRange(0, text!.count))
        
        attributedText = attributedString
    }
}
