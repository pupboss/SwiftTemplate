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
    
    class func backgroundColor() -> UIColor {
        return UIColor.white
    }
    
    class func subBackgroundColor() -> UIColor {
        return UIColor(r: 250, g: 250, b: 250)
    }
    
    class func themeColor() -> UIColor {
        return UIColor(r: 60, g: 50, b: 171)
    }
    
    class func textColor() -> UIColor {
        return UIColor(r: 23, g: 22, b: 22)
    }
    
    class func lineColor() -> UIColor {
        return UIColor(r: 217, g: 217, b: 217)
    }
    
    class func titleTextColor() -> UIColor {
        return UIColor.black
    }
    
    class func descTextColor() -> UIColor {
        return UIColor.lightGray
    }
    
    class func disableTextColor() -> UIColor {
        return UIColor.lightGray
    }
    
    class func dangerTextColor() -> UIColor {
        return UIColor(r: 241, g: 89, b: 94)
    }
    
    class func tintColor() -> UIColor {
        return UIColor(r: 183, g: 162, b: 222)
    }
}
