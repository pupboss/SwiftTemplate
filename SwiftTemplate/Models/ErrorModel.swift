//
//  ErrorModel.swift
//  SwiftTemplate
//
//  Created by Jie Li on 1/6/18.
//  Copyright © 2018 Meltdown Research. All rights reserved.
//

import Foundation

struct ErrorModel: Error, Codable {
    
    let code: Int
    let message: String
}
