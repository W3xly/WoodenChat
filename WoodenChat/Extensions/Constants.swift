//
//  Constants.swift
//  WoodenChat
//
//  Created by Johana Šlechtová on 16/06/2020.
//  Copyright © 2020 Jan Podmolík. All rights reserved.
//

import Firebase

let COLLECTION_MESSAGES = Firestore.firestore().collection("messages")
let COLLECTION_USERS = Firestore.firestore().collection("users")

// user

let kUID = "uid"
let kPROFILEIMAGEURL = "profileImageUrl"
let kUSERNAME = "username"
let kFULLNAME = "fullname"
let kEMAIL = "email"

// message

let kTEXT = "text"
let kTOID = "toId"
let kFROMID = "fromId"
let kTIMESTAMP = "timestamp"

let kRECENTMESSAGES = "recent-messages"
