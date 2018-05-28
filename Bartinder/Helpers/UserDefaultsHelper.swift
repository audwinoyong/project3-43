//
//  UserDefaultsHelper.swift
//  Bartinder
//
//  Created by Jason Kumar on 15.05.18.
//  Copyright © 2018 Bartinder. All rights reserved.
//

import Foundation

class UserDefaultsHelper
{
    static func setHasSeenTutorial(_ hasSeenTutorial: Bool)
    {
        UserDefaults.standard.set(hasSeenTutorial, forKey: "hasSeenTutorial")
    }
    
    static func getHasSeenTutorial() -> Bool
    {
        return UserDefaults.standard.bool(forKey: "hasSeenTutorial")
    }
}
