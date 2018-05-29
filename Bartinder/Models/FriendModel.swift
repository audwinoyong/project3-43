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
    
    var dictionary: [String: String] {
        return [
            "id": id,
            "name": name
        ]
    }
    
    init() {
        self.id = ""
        self.name = ""
    }
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    init(with snapshot: DataSnapshot) {
        self.init()
        
        if snapshot.hasChild("id") {
            id = snapshot.childSnapshot(forPath: "id").value as! String
        }
        if snapshot.hasChild("name") {
            name = snapshot.childSnapshot(forPath: "name").value as! String
        }
    }
}
