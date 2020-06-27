//
//  UserInfoModel.swift
//  SwiftTemplate
//
//  Created by Jie Li on 5/6/18.
//  Copyright © 2018 Meltdown Research. All rights reserved.
//

import Foundation

struct UserInfoModel : Codable {
    let id: String
    let email: String
    let name: String
    let publicKey: String
    let role: String
    let userStatus: UserStatus
}
