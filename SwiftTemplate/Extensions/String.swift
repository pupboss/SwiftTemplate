//
//  String.swift
//  SwiftTemplate
//
//  Created by Jet Lee on 31/5/18.
//  Copyright © 2018 PUPBOSS. All rights reserved.
//

import Foundation

extension String {
    
    func trimLeft(withTargetString target: String) -> String {
        
        if hasPrefix(target) {
            let aString = String(suffix(from: target.endIndex))
            return aString.trimLeft(withTargetString:target)
        } else {
            return self
        }
    }
    
    var notificationName: NSNotification.Name {
        return NSNotification.Name(rawValue: self)
    }
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self, options: Data.Base64DecodingOptions(rawValue: 0)) else {
            return nil
        }
        
        return String(data: data as Data, encoding: String.Encoding.utf8)
    }
    
    func toBase64() -> String? {
        guard let data = self.data(using: String.Encoding.utf8) else {
            return nil
        }
        
        return data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    }
}
