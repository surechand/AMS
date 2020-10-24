//
//  ImageManagement.swift
//  Lifty
//
//  Created by Angelika Jeziorska on 14/04/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Firebase

class ImageManagement {
    
    static let shareInstance = ImageManagement()
    let user = Auth.auth().currentUser
    let storage = Storage.storage()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveToStorage (data: Data) {
        let storageRef = storage.reference()
        if let user = user {
            let newUserPictureRef = storageRef.child("UserProfileImages/" + (user.displayName!.trimmingCharacters(in: .whitespacesAndNewlines)) + ".jpg")
            
            // Upload the file to the path
            let uploadTask = newUserPictureRef.putData(data, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    // An error occurred!
                    return
                }
                let size = metadata.size
                newUserPictureRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        return
                    }
                    //                    assign the picture to user
                    metadata.contentType = "image/jpg"
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.photoURL = downloadURL
                    changeRequest?.commitChanges { (error) in
                        
                    }
                }
            }
        }
    }
    
    
    func deleteImage () {
        let storageRef = storage.reference()
        if let user = user {
            let userPictureRef = storageRef.child("UserProfileImages/" + (user.displayName!.trimmingCharacters(in: .whitespacesAndNewlines)) + ".jpg")
            
            userPictureRef.delete { error in
                if let error = error {
                    // An error occurred!
                } else {
                    // File deleted successfully
                }
            }
        }
    }
    
}

