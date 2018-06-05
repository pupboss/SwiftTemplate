//
//  Date.swift
//  SwiftTemplate
//
//  Created by Jet Lee on 29/5/18.
//  Copyright © 2018 PUPBOSS. All rights reserved.
//

import Foundation

extension Date {
    
    func formattedString(withDateFormat dateFormat: String) -> String {
        
        let f = DateFormatter()
        f.dateFormat = dateFormat
        return f.string(from: self)
    }
}
