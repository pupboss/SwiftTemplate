//
//  PublicService.swift
//  MeltdownPlatform
//
//  Created by Jie Li on 2/7/20.
//  Copyright © 2020 Meltdown Research. All rights reserved.
//

import UIKit

class PublicService {
    static let `default` = PublicService()
    
    var displayName: String
    var bundleName: String
    var versionString: String
    var buildString: String
    var deviceModel: String
    var systemVersion: String
    
    var userInfo: UserInfoModel
    
    init() {
        userInfo = UserInfoModel(userId: "", email: "", name: "", publicKey: "", role: "", userStatus: .normal)
        displayName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? ""
        bundleName = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
        versionString = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        buildString = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
        systemVersion = UIDevice.current.systemVersion
        deviceModel = PublicService.getDeviceModel()
    }
    
    
    
    private class func getDeviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        let modelDict = [
            "AppleTV1,1": "Apple TV 1",
            "AppleTV2,1": "Apple TV 2",
            "AppleTV3,1": "Apple TV 3",
            "AppleTV3,2": "Apple TV 3",
            "AppleTV5,3": "Apple TV 4",
            "AppleTV6,2": "Apple TV 4K",
            
            "Watch1,1": "Apple Watch 1",
            "Watch1,2": "Apple Watch 1",
            "Watch2,6": "Apple Watch Series 1",
            "Watch2,7": "Apple Watch Series 1",
            "Watch2,3": "Apple Watch Series 2",
            "Watch2,4": "Apple Watch Series 2",
            "Watch3,1": "Apple Watch Series 3",
            "Watch3,2": "Apple Watch Series 3",
            "Watch3,3": "Apple Watch Series 3",
            "Watch3,4": "Apple Watch Series 3",
            "Watch4,1": "Apple Watch Series 4",
            "Watch4,2": "Apple Watch Series 4",
            "Watch4,3": "Apple Watch Series 4",
            "Watch4,4": "Apple Watch Series 4",
            
            "AudioAccessory1,1": "HomePod",
            "AudioAccessory1,2": "HomePod",
            
            "iPhone1,1": "iPhone 2G",
            "iPhone1,2": "iPhone 3G",
            "iPhone2,1": "iPhone 3GS",
            "iPhone3,1": "iPhone 4",
            "iPhone3,2": "iPhone 4",
            "iPhone3,3": "iPhone 4",
            "iPhone4,1": "iPhone 4s",
            "iPhone5,1": "iPhone 5",
            "iPhone5,2": "iPhone 5",
            "iPhone5,3": "iPhone 5c",
            "iPhone5,4": "iPhone 5c",
            "iPhone6,1": "iPhone 5s",
            "iPhone6,2": "iPhone 5s",
            "iPhone7,1": "iPhone 6 Plus",
            "iPhone7,2": "iPhone 6",
            "iPhone8,1": "iPhone 6s",
            "iPhone8,2": "iPhone 6s Plus",
            "iPhone8,4": "iPhone SE",
            "iPhone9,1": "iPhone 7",
            "iPhone9,3": "iPhone 7",
            "iPhone9,2": "iPhone 7 Plus",
            "iPhone9,4": "iPhone 7 Plus",
            "iPhone10,1": "iPhone 8",
            "iPhone10,4": "iPhone 8",
            "iPhone10,2": "iPhone 8 Plus",
            "iPhone10,5": "iPhone 8 Plus",
            "iPhone10,3": "iPhone X",
            "iPhone10,6": "iPhone X",
            "iPhone11,8": "iPhone XR",
            "iPhone11,2": "iPhone XS",
            "iPhone11,6": "iPhone XS Max",
            "iPhone12,1": "iPhone 11",
            "iPhone12,3": "iPhone 11 Pro",
            "iPhone12,5": "iPhone 11 Pro Max",
            "iPhone12,8": "iPhone SE 2",
            
            "iPod1,1": "iPod Touch 1",
            "iPod2,1": "iPod Touch 2",
            "iPod3,1": "iPod Touch 3",
            "iPod4,1": "iPod Touch 4",
            "iPod5,1": "iPod Touch 5",
            "iPod7,1": "iPod Touch 6",
            "iPod9,1": "iPod Touch 7",
            
            "iPad1,1": "iPad 1",
            "iPad2,1": "iPad 2",
            "iPad2,2": "iPad 2",
            "iPad2,3": "iPad 2",
            "iPad2,4": "iPad 2",
            "iPad3,1": "iPad 3",
            "iPad3,2": "iPad 3",
            "iPad3,3": "iPad 3",
            "iPad3,4": "iPad 4",
            "iPad3,5": "iPad 4",
            "iPad3,6": "iPad 4",
            "iPad6,11": "iPad 5",
            "iPad6,12": "iPad 5",
            "iPad7,5": "iPad 6",
            "iPad7,6": "iPad 6",
            "iPad7,11": "iPad 7",
            "iPad7,12": "iPad 7",
            "iPad4,1": "iPad Air",
            "iPad4,2": "iPad Air",
            "iPad4,3": "iPad Air",
            "iPad5,3": "iPad Air 2",
            "iPad5,4": "iPad Air 2",
            "iPad11,3": "iPad Air 3",
            "iPad11,4": "iPad Air 3",
            "iPad6,7": "iPad Pro (12.9 inch)",
            "iPad6,8": "iPad Pro (12.9 inch)",
            "iPad6,3": "iPad Pro (9.7 inch)",
            "iPad6,4": "iPad Pro (9.7 inch)",
            "iPad7,1": "iPad Pro (12.9 inch) 2",
            "iPad7,2": "iPad Pro (12.9 inch) 2",
            "iPad7,3": "iPad Pro (10.5 inch)",
            "iPad7,4": "iPad Pro (10.5 inch)",
            "iPad8,1": "iPad Pro (11 inch)",
            "iPad8,2": "iPad Pro (11 inch)",
            "iPad8,3": "iPad Pro (11 inch)",
            "iPad8,4": "iPad Pro (11 inch)",
            "iPad8,5": "iPad Pro (12.9 inch) 3",
            "iPad8,6": "iPad Pro (12.9 inch) 3",
            "iPad8,7": "iPad Pro (12.9 inch) 3",
            "iPad8,8": "iPad Pro (12.9 inch) 3",
            "iPad8,9": "iPad Pro (11 inch) 2",
            "iPad8,10": "iPad Pro (11 inch) 2",
            "iPad8,11": "iPad Pro (12.9 inch) 4",
            "iPad8,12": "iPad Pro (12.9 inch) 4",
            "iPad2,5": "iPad mini 1",
            "iPad2,6": "iPad mini 1",
            "iPad2,7": "iPad mini 1",
            "iPad4,4": "iPad mini 2",
            "iPad4,5": "iPad mini 2",
            "iPad4,6": "iPad mini 2",
            "iPad4,7": "iPad mini 3",
            "iPad4,8": "iPad mini 3",
            "iPad4,9": "iPad mini 3",
            "iPad5,1": "iPad mini 4",
            "iPad5,2": "iPad mini 4",
            "iPad11,1": "iPad mini 5",
            "iPad11,2": "iPad mini 5",
            "i386": "iPhone Simulator",
            "x86_64": "iPhone Simulator",
        ]
        return modelDict[identifier] ?? identifier
    }
}
