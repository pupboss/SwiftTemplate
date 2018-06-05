//
//  UIImage.swift
//  SwiftTemplate
//
//  Created by Jet Lee on 31/5/18.
//  Copyright © 2018 PUPBOSS. All rights reserved.
//

import UIKit

extension UIImage {
    
    class func fromColor(color: UIColor) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}
