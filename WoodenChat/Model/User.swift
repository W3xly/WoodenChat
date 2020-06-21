//
//  User.swift
//  WoodenChat
//
//  Created by Johana Šlechtová on 17/06/2020.
//  Copyright © 2020 Jan Podmolík. All rights reserved.
//

import Foundation

struct User {
    let uid: String
    let profileImageUrl: String
    let username: String
    let fullname: String
    let email: String
    
    init(dictionary: [String : Any]) {
        self.uid = dictionary[kUID] as? String ?? ""
        self.profileImageUrl = dictionary[kPROFILEIMAGEURL] as? String ?? ""
        self.username = dictionary[kUSERNAME] as? String ?? ""
        self.fullname = dictionary[kFULLNAME] as? String ?? ""
        self.email = dictionary[kEMAIL] as? String ?? ""
    }
}
