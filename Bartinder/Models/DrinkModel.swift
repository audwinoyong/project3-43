//
//  DrinkModel.swift
//  Bartinder
//
//  Created by Jason Kumar on 11.05.18.
//  Copyright © 2018 Bartinder. All rights reserved.
//

import Foundation
import SwiftyJSON
import Firebase

struct DrinkModel: SnapshotParser
{
    var id: String
    var name: String
    var imgUrl: String
    var alcoholicType: String
    var glass: String
    var instructions: String
    var ingredientsAndMeasurements: [(String, String)]
    
    init() {
        id = ""
        name = ""
        imgUrl = ""
        alcoholicType = ""
        glass = ""
        instructions = ""
        ingredientsAndMeasurements = [(String, String)]()
    }
    
    var dictionary: [String: String] {
        return [
            "id": id,
            "name": name,
            "imgURL": imgUrl
        ]
    }
    
    init(with snapshot: DataSnapshot) {
        self.init()
        
        if snapshot.hasChild("id") {
            id = snapshot.childSnapshot(forPath: "id").value as! String
        }
        if snapshot.hasChild("name") {
            name = snapshot.childSnapshot(forPath: "name").value as! String
        }
        if snapshot.hasChild("imgURL") {
            imgUrl = snapshot.childSnapshot(forPath: "imgURL").value as! String
        }
    }
    
    init(json: JSON)
    {
        self.init()
        
        if let id = json["idDrink"].string {
            self.id = id
        }
        
        if let name = json["strDrink"].string {
            self.name = name
        }
        
        if let imgUrl = json["strDrinkThumb"].string {
            self.imgUrl = imgUrl
        }
        
        if let alcoholicType = json["strAlcoholic"].string {
            self.alcoholicType = alcoholicType
        }
        
        if let glass = json["strGlass"].string {
            self.glass = glass
        }
        
        if let instructions = json["strInstructions"].string {
            self.instructions = instructions
        }
        
        for index in 1...15 {
            if let ingredient = json["strIngredient\(index)"].string, let measure = json["strMeasure\(index)"].string {
                let safeIngredient = ingredient.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\r", with: "")
                let safeMeasurement = measure.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\r", with: "")
                
                if safeIngredient.count + safeMeasurement.count == 0 {
                    continue
                }
                
                self.ingredientsAndMeasurements.append((ingredient, measure))
            }
        }
    }
}
