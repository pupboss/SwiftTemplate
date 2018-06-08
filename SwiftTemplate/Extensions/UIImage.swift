//
//  UIImage.swift
//  SwiftTemplate
//
//  Created by Jet Lee on 31/5/18.
//  Copyright © 2018 PUPBOSS. All rights reserved.
//

import UIKit

extension UIImage {
    
    class func fromColor(_ color: UIColor) -> UIImage {
        
        let rect = CGRect(origin: .zero, size: CGSize(width: 1, height: 1))
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
