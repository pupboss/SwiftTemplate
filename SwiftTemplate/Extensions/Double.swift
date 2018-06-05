//
//  Double.swift
//  SwiftTemplate
//
//  Created by Jet Lee on 31/5/18.
//  Copyright © 2018 PUPBOSS. All rights reserved.
//

import Foundation

extension Double {
    
    func priceString() -> String {
        
        return String(format: "%0.2f", self)
    }
}
