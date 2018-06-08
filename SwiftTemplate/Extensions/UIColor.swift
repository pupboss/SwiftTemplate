//
//  UIColor.swift
//  SwiftTemplate
//
//  Created by Jet Lee on 5/6/18.
//  Copyright © 2018 PUPBOSS. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    /// tc means theme color
    struct tc {
        static var background: UIColor { return .white }
        static var subBackground: UIColor { return UIColor(r: 250, g: 250, b: 250) }
        static var theme: UIColor { return UIColor(r: 60, g: 50, b: 171) }
        static var text: UIColor { return UIColor(r: 23, g: 22, b: 22) }
        static var line: UIColor { return UIColor(r: 217, g: 217, b: 217) }
        static var titleText: UIColor { return .black }
        static var descText: UIColor { return .lightGray }
        static var disableText: UIColor { return .lightGray }
        static var dangerText: UIColor { return UIColor(r: 241, g: 89, b: 94) }
        static var tint: UIColor { return UIColor(r: 183, g: 162, b: 222) }
    }
}
