//
//  UIKit.swift
//  SwiftTemplate
//
//  Created by Jie Li on 31/5/18.
//  Copyright © 2018 Meltdown Research. All rights reserved.
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
        static var buttonText: UIColor { return UIColor.gray }
        static var buttonHighlightedText: UIColor { return UIColor.darkGray }
    }
}

extension UILabel {
    func changeCharacterSpace(_ space: CGFloat) {
        text = text ?? ""
        let attributedString = NSMutableAttributedString(string: text!, attributes: [.kern: space])
        let paragraphStyle = NSMutableParagraphStyle()
        attributedString.addAttributes([.paragraphStyle: paragraphStyle], range: NSMakeRange(0, text!.count))
        
        attributedText = attributedString
    }
}

extension UITextField {
    func changeCharacterSpace(_ space: CGFloat) {
        text = text ?? ""
        let attributedString = NSMutableAttributedString(string: text!, attributes: [.kern: space])
        let paragraphStyle = NSMutableParagraphStyle()
        attributedString.addAttributes([.paragraphStyle: paragraphStyle], range: NSMakeRange(0, text!.count))
        
        attributedText = attributedString
    }
}

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
    
    class func fromView(_ view: UIView) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
}

extension UIScreen {
    
    private static let step: CGFloat = 0.1
    
    static func animateBrightness(to value: CGFloat) {
        guard abs(UIScreen.main.brightness - value) > step else { return }
        
        let delta = UIScreen.main.brightness > value ? -step : step
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            UIScreen.main.brightness += delta
            animateBrightness(to: value)
        }
    }
}
