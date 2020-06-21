//
//  AuthService.swift
//  WoodenChat
//
//  Created by Johana Šlechtová on 17/06/2020.
//  Copyright © 2020 Jan Podmolík. All rights reserved.
//

import Firebase
import UIKit

struct RegistrationCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
    
}

struct AuthService {
    
    static func logUserIn(withEmail email: String, withPassword password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func createUser(credentials: RegistrationCredentials, completion: ((Error?) -> Void)?) {
        
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else { return }
        let filename = NSUUID().uuidString // specific ID for every image
        let ref = Storage.storage().reference(withPath: "/profile_images/\(filename)")
        
        ref.putData(imageData, metadata: nil) { (meta, error) in
            if let error = error {
                completion!(error)
                return
            }
            ref.downloadURL { (url, error) in
                // full URL of image
                guard let profileImageURL = url?.absoluteString else { return }

                Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (result, error) in
                    if let error = error {
                        completion!(error)
                        return
                    }
                    guard let uid = result?.user.uid else { return }
                    
                    let data = [kEMAIL: credentials.email,
                                kFULLNAME: credentials.fullname,
                                kPROFILEIMAGEURL: profileImageURL,
                                kUID: uid,
                                kUSERNAME: credentials.username] as [String : Any]
                    
                    Firestore.firestore().collection("users").document(uid).setData(data, completion: completion)
                }
            }
        }
    }
}
