//
//  DrinkService.swift
//  Bartinder
//
//  Created by Andreas Lengkeek on 19/5/18.
//  Copyright © 2018 Bartinder. All rights reserved.
//

import Foundation
import Firebase

struct DrinkService {
    
    var ref: DatabaseReference
    
    init() {
        ref = Database.database().reference().child("drinks")
    }
    
    func saveDrinkFor(userId: String, _ drink: DrinkModel) {
        // save record under user id
        ref.child(userId).childByAutoId().setValue(drink.dictionary)
    }
    

    func getDrinksFor(userId: String, callback: (([DrinkModel]) -> Void)?) {
        var drinks: [DrinkModel] = []
        
        ref.child(userId).observe(.value) { snapshot in
            guard snapshot.hasChildren() else {
                return
            }
            
            drinks.removeAll()
            
            for child in snapshot.children {
                drinks.append(DrinkModel(with: child as! DataSnapshot))
            }
            
            callback?(drinks)
        };
    }
}
