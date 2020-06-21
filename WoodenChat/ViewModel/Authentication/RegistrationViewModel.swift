//
//  RegistrationViewModel.swift
//  WoodenChat
//
//  Created by Johana Šlechtová on 17/06/2020.
//  Copyright © 2020 Jan Podmolík. All rights reserved.
//

import Foundation

struct RegistrationViewModel: AuthenticationProtocol {
    
    var email: String?
    var fullName: String?
    var userName: String?
    var password: String?
    
     // Check if whole form is filled
    
    var formIsValid: Bool {
        return email?.isEmpty == false
            && fullName?.isEmpty == false
            && userName?.isEmpty == false
            && password?.isEmpty == false
    }
}
