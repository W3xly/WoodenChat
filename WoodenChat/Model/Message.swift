//
//  Message.swift
//  WoodenChat
//
//  Created by Johana Šlechtová on 18/06/2020.
//  Copyright © 2020 Jan Podmolík. All rights reserved.
//

import Firebase

struct Message {
    var user: User?
    
    let text: String
    let toId: String
    let fromId: String
    let timestamp: Timestamp!
    let isFromCurrentUser: Bool
    
    var chatPartnerId: String {
        if Auth.auth().currentUser!.uid == toId {
            return fromId
        } else {
            return toId
        }
    }
    
    var loggedUserId: String {
        if Auth.auth().currentUser!.uid == toId {
            return toId
        } else {
            return fromId
        }
    }
    
    init(dictionary: [String : Any]) {
        self.text = dictionary[kTEXT] as? String ?? ""
        self.toId = dictionary[kTOID] as? String ?? ""
        self.fromId = dictionary[kFROMID] as? String ?? ""
        self.timestamp = dictionary[kTIMESTAMP] as? Timestamp ?? Timestamp(date: Date())
        self.isFromCurrentUser = fromId == Auth.auth().currentUser?.uid
    }
}
