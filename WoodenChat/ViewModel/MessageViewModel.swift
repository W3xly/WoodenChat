//
//  MessageViewModel.swift
//  WoodenChat
//
//  Created by Johana Šlechtová on 18/06/2020.
//  Copyright © 2020 Jan Podmolík. All rights reserved.
//

import UIKit

struct MessageViewModel {
    
    private let message: Message
    
    var messageBackgroundColor: UIColor {
        return message.isFromCurrentUser ? #colorLiteral(red: 0.9472051451, green: 0.7384672713, blue: 0.4655679521, alpha: 1) : #colorLiteral(red: 0.243119448, green: 0.1592523555, blue: 0.1054103304, alpha: 1)
    }
    
    var messageTextColor: UIColor {
        return message.isFromCurrentUser ? #colorLiteral(red: 0.243119448, green: 0.1592523555, blue: 0.1054103304, alpha: 1) : #colorLiteral(red: 0.9472051451, green: 0.7384672713, blue: 0.4655679521, alpha: 1)
    }
    
    var rightAnchorActive: Bool {
        return message.isFromCurrentUser
    }
    
    var leftAnchorActive: Bool {
        return !message.isFromCurrentUser
    }
    
    var shouldHideProfileImage: Bool {
        return message.isFromCurrentUser
    }
    
    var profileImageUrl: URL? {
        guard let user = message.user else { return nil }
        return URL(string: user.profileImageUrl)
    }
    
    init(message: Message) {
        self.message = message
    }
}
