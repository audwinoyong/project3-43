//
//  FriendService.swift
//  Bartinder
//
//  Created by Andreas Lengkeek on 28/5/18.
//  Copyright © 2018 Bartinder. All rights reserved.
//

import Foundation
import Firebase

struct FriendService {
    
    var friendsRef: DatabaseReference
    var usersRef: DatabaseReference
    
    init() {
        friendsRef = Database.database().reference().child("friends")
        usersRef = Database.database().reference().child("users")
    }
    
    func getFriendsFor(userId: String, callback: ((FriendModel) -> Void)?) {
        friendsRef.child(userId).observe(.childAdded) { snapshot in
            callback!(FriendModel(with: snapshot))
        }
    }
    
    func addFriendFor(userId: String, friend: FriendModel) {
        friendsRef.child(userId).child(friend.id).setValue(friend.dictionary);
    }
    
    func removeFriendFor(userId: String, friend: FriendModel) {
        friendsRef.child(userId).child(friend.id).removeValue()
    }

    func addUser(user: FriendModel) {
        usersRef.child(user.id).setValue(user.dictionary);
    }
    
    func getUsers(userId: String, callback: ((FriendModel) -> Void)?) {
        usersRef.observe(.childAdded) { snapshot in
            if snapshot.key != userId {
                callback!(FriendModel(with: snapshot))
            }
        }
    }
}
