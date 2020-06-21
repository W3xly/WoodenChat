//
//  Service.swift
//  WoodenChat
//
//  Created by Johana Šlechtová on 18/06/2020.
//  Copyright © 2020 Jan Podmolík. All rights reserved.
//

import Firebase

struct Service {
    
    static func fetchUsers(completion: @escaping([User]) -> Void) {
        COLLECTION_USERS.getDocuments { (snapshot, error) in
            guard var users = snapshot?.documents.map({ User(dictionary: $0.data())}) else { return }
            // remove currently logged in user from list
            if let index = users.firstIndex(where: {$0.uid == Auth.auth().currentUser?.uid }) {
                users.remove(at: index)
            }
            completion(users)
        }
    }
    
    static func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
        COLLECTION_USERS.document(uid).getDocument { (snapshot, error) in
            guard let dictionary = snapshot?.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
    
    static func fetchConversations(completion: @escaping([Conversation]) -> Void) {
        var conversations = [Conversation]()
        var conversationsDictionary = [String : Conversation]()
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let query = COLLECTION_MESSAGES.document(uid).collection(kRECENTMESSAGES).order(by: kTIMESTAMP)
        // need snapshot listener to keep recent message updated
        query.addSnapshotListener { (snapshot, error) in
            snapshot?.documentChanges.forEach({ change in
                let dictionary = change.document.data()
                let message = Message(dictionary: dictionary)
                
                self.fetchUser(withUid: message.chatPartnerId) { user in
                    let conversation = Conversation(user: user, message: message)
                    // Need key value pairs to avoid duplicate messages from one user..
                    conversationsDictionary.updateValue(conversation, forKey: message.chatPartnerId)
                    // For some reason after relog appears conversation of user with himself - so I remove it manualy every time it happens..
                    conversationsDictionary.removeValue(forKey: message.loggedUserId)
                    conversations = Array(conversationsDictionary.values)
                    completion(conversations)
                }
            })
        }
    }
    
    static func fetchMessages(forUser user: User, completion: @escaping([Message]) -> Void) {
        var messages = [Message]()
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let query = COLLECTION_MESSAGES.document(currentUid).collection(user.uid).order(by: kTIMESTAMP)
        query.addSnapshotListener { (snapshot, error) in // snapshot of listener
            snapshot?.documentChanges.forEach { change in // all document changes
                if change.type == .added { // if something is added
                    let dictionary = change.document.data() // added document
                    messages.append(Message(dictionary: dictionary))
                    completion(messages)
                }
            }
        }
    }
    
    static func uploadMessage(_ message: String, to user: User, completion: ((Error?) -> Void)?) {
        
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        let data = [kTEXT: message,
                    kTOID: user.uid,
                    kFROMID: currentUserId,
                    kTIMESTAMP: Timestamp(date: Date())] as [String : Any]
        
        // Upload to current user
        COLLECTION_MESSAGES.document(currentUserId).collection(user.uid).addDocument(data: data) { _ in
            // Upload to user whom is message sended
            COLLECTION_MESSAGES.document(user.uid).collection(currentUserId).addDocument(data: data, completion: completion)
            // Upload / Refresh recent message to current user
            COLLECTION_MESSAGES.document(currentUserId).collection(kRECENTMESSAGES).document(user.uid).setData(data)
            // Upload / Refresh recent message to user whom is message sended
            COLLECTION_MESSAGES.document(user.uid).collection(kRECENTMESSAGES).document(currentUserId).setData(data)
            
        }
    }
}
