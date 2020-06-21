//
//  ConversationViewModel.swift
//  WoodenChat
//
//  Created by Johana Šlechtová on 19/06/2020.
//  Copyright © 2020 Jan Podmolík. All rights reserved.
//

import Foundation

struct ConversationViewModel {
    
    private let conversation: Conversation
    
    var profileImageUrl: URL? {
        return URL(string: conversation.user.profileImageUrl)
    }
    
    var timestamp: String {
        let dateFormatter = DateFormatter()
        let date = conversation.message.timestamp.dateValue()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date)
    }
    
    
    init(conversation: Conversation) {
        self.conversation = conversation
    }
}
