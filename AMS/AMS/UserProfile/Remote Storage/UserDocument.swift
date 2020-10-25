//
//  UserDocumentManagement.swift
//  AMS
//
//  Created by Angelika Jeziorska on 17/10/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import Foundation
import Firebase

class UserDocument {
    
    var name: String?
    var surname: String?
    var email: String?
    var userRef: DocumentReference? = nil
    
    let db = Firestore.firestore()
    var uid: String
    
    init(uid: String) {
        self.uid = uid
    }
    
    func setUserDocument (name: String, surname: String, email: String) {
        self.userRef!.setData([
            "name": name,
            "surname": surname,
            "email": email
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func setUserExtraData (address: String, city: String, postcode: String, country: String, phoneNumber: String) {
        self.userRef!.setData([
            "address": address,
            "city": city,
            "postcode": postcode,
            "country": country,
            "phoneNumber": phoneNumber
        ], merge: true) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
}
