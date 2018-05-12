//
//  DrinkModel.swift
//  Bartinder
//
//  Created by Jason Kumar on 11.05.18.
//  Copyright © 2018 Bartinder. All rights reserved.
//

import Foundation
import SwiftyJSON

struct DrinkModel
{
    var id: String
    var name: String
    var imgUrl: String
    
    init(json: JSON)
    {
        self.id = json["idDrink"].string!
        self.name = json["strDrink"].string!
        self.imgUrl = json["strDrinkThumb"].string!
    }
}
