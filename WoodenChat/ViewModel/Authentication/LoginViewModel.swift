//
//  LoginViewModel.swift
//  WoodenChat
//
//  Created by Johana Šlechtová on 17/06/2020.
//  Copyright © 2020 Jan Podmolík. All rights reserved.
//

import Foundation

protocol AuthenticationProtocol {
    var formIsValid: Bool { get }
}

struct LoginViewModel: AuthenticationProtocol {
    
    var email: String?
    var password: String?
    
// Check if whole form is filled
    var formIsValid: Bool {
        return email?.isEmpty == false
            && password?.isEmpty == false
    }
}
