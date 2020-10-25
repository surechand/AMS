//
//  Document.swift
//  AMS
//
//  Created by Angelika Jeziorska on 17/10/2020.
//  Copyright © 2020 Angelika Jeziorska. All rights reserved.
//

import Foundation
import Firebase

class Document {
    let db = Firestore.firestore()
    var key: String
    
    init(key: String) {
        self.key = key
    }
}
