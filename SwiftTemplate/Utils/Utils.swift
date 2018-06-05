//
//  Utils.swift
//  SwiftTemplate
//
//  Created by Jet Lee on 29/5/18.
//  Copyright © 2018 PUPBOSS. All rights reserved.
//

import UIKit

class Utils {
    class func priceWithCurrencySymbol(currency: String, price: String) -> String {
        var currencySymbol = "S$"
        if currency.uppercased() == "USD" {
            currencySymbol = "$"
        } else if currency.uppercased() == "SGD" {
            currencySymbol = "S$"
        } else if currency.uppercased() == "CNY" {
            currencySymbol = "￥"
        } else {
            currencySymbol = "$"
        }
        
        return "\(currencySymbol)\(price)"
    }
    
    class func appName() -> String {
        return Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
    }
    
    class func appVersion() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    }
    
    class func appBuild() -> String {
        return Bundle.main.infoDictionary![kCFBundleVersionKey as String] as! String
    }
    
    class func deviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "AppleTV2,1":                                      return "Apple TV 2G"
        case "AppleTV3,1", "AppleTV3,2":                        return "Apple TV 3G"
        case "AppleTV5,3":                                      return "Apple TV 4G"
        case "AppleTV6,2":                                      return "Apple TV 4K"
        
        case "Watch1,1", "Watch1,2":                            return "Apple Watch 1"
        case "Watch2,3", "Watch2,4":                            return "Apple Watch Series 2"
        case "Watch2,6", "Watch2,7":                            return "Apple Watch Series 1"
        case "Watch3,1", "Watch3,2", "Watch3,3", "Watch3,4":    return "Apple Watch Series 3"
        
        case "iPhone1,1":                                       return "iPhone 2G"
        case "iPhone1,2":                                       return "iPhone 3G"
        case "iPhone2,1":                                       return "iPhone 3GS"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":             return "iPhone 4"
        case "iPhone4,1":                                       return "iPhone 4S"
        case "iPhone5,1", "iPhone5,2":                          return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                          return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                          return "iPhone 5s"
        case "iPhone7,1":                                       return "iPhone 6 Plus"
        case "iPhone7,2":                                       return "iPhone 6"
        case "iPhone8,1":                                       return "iPhone 6s"
        case "iPhone8,2":                                       return "iPhone 6s Plus"
        case "iPhone8,4":                                       return "iPhone SE"
        case "iPhone9,1", "iPhone9,3":                          return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                          return "iPhone 7 Plus"
        case "iPhone10,1", "iPhone10,4":                        return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                        return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                        return "iPhone X"
            
        case "iPod1,1":                                         return "iPod Touch 1"
        case "iPod2,1":                                         return "iPod Touch 2"
        case "iPod3,1":                                         return "iPod Touch 3"
        case "iPod4,1":                                         return "iPod Touch 4"
        case "iPod5,1":                                         return "iPod Touch 5"
        case "iPod7,1":                                         return "iPod Touch 6"
            
        case "iPad1,1":                                         return "iPad 1"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":        return "iPad 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":                   return "iPad Mini 1G"
        case "iPad3,1", "iPad3,2", "iPad3,3":                   return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":                   return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":                   return "iPad Air"
        case "iPad4,4", "iPad4,5", "iPad4,6":                   return "iPad Mini 2G"
        case "iPad4,7", "iPad4,8", "iPad4,9":                   return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                              return "iPad mini 4"
        case "iPad5,3", "iPad5,4":                              return "iPad Air 2"
        case "iPad6,3", "iPad6,4":                              return "iPad Pro (9.7 inch)"
        case "iPad6,7", "iPad6,8":                              return "iPad Pro (12.9 inch)"
        case "iPad6,11", "iPad6,12":                            return "iPad 5"
        case "iPad7,1", "iPad7,2":                              return "iPad Pro 2 (12.9 inch)"
        case "iPad7,3", "iPad7,4":                              return "iPad Pro (10.5 inch)"
        case "iPad7,5", "iPad7,6":                              return "iPad 6"
            
        case "i386", "x86_64":                                  return "iPhone Simulator"
        default: return identifier
        }
    }
    
    class func systemVersion() -> String {
        return UIDevice.current.systemVersion
    }
}
