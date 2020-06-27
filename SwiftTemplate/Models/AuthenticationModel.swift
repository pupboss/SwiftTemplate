//
//  AuthenticationModel.swift
//  MeltdownPlatform
//
//  Created by Jie Li on 27/6/20.
//  Copyright © 2020 Jie Li. All rights reserved.
//

import Foundation

public enum UserStatus : Int, Codable {
    
    case normal = 0
    case suspended
}

struct AuthenticationModel : Codable {
    
    let loginToken: String
    let role: String
    let userStatus: UserStatus
    var userStatusString: String {
        switch userStatus {
        case .normal:
            return "Normal"
        case .suspended:
            return "Suspended"
        }
    }
}
