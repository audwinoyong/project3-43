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
    var id = ""
    var name = ""
    var imgUrl = ""
    var alcoholicType = ""
    var glass = ""
    var instructions = ""
    var ingredientsAndMeasurements = [(String, String)]()
    
    init(json: JSON)
    {
        if let id = json["idDrink"].string
        {
            self.id = id
        }
        
        if let name = json["strDrink"].string
        {
            self.name = name
        }
        
        if let imgUrl = json["strDrinkThumb"].string
        {
            self.imgUrl = imgUrl
        }
        
        if let alcoholicType = json["strAlcoholic"].string
        {
            self.alcoholicType = alcoholicType
        }
        
        if let glass = json["strGlass"].string
        {
            self.glass = glass
        }
        
        if let instructions = json["strInstructions"].string
        {
            self.instructions = instructions
        }
        
        for index in 1...15
        {
            if let ingredient = json["strIngredient\(index)"].string, let measure = json["strMeasure\(index)"].string
            {
                let safeIngredient = ingredient.replacingOccurrences(of: " ", with: "")
                let safeMeasurement = measure.replacingOccurrences(of: " ", with: "")
                
                if safeIngredient.count + safeMeasurement.count == 0
                {
                    continue
                }
                
                self.ingredientsAndMeasurements.append((ingredient, measure))
            }
        }
    }
}
