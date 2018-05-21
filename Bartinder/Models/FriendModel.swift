//
//  FriendModel.swift
//  Bartinder
//
//  Created by Audwin on 21/5/18.
//  Copyright © 2018 Bartinder. All rights reserved.
//

import Foundation
import Firebase

struct FriendModel {
    var id: String
    var name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
}
