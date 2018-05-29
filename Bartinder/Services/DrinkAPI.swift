//
//  DrinkAPI.swift
//  Bartinder
//
//  Created by Andreas Lengkeek on 20/5/18.
//  Copyright © 2018 Bartinder. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct DrinkAPI {
    
    private static var API_URL = "https://www.thecocktaildb.com/api/json/v1/1"
    
    static func filterByIngredient(ingredient: String, callback: (([DrinkModel]) -> Void)?) {
        let safeIng = ingredient.replacingOccurrences(of: " ", with: "_")
        var drinks: [DrinkModel] = []
        Alamofire.request("\(API_URL)/filter.php?i=\(safeIng)").responseJSON { response in
            if response.result.isSuccess {
                if let drinkArray = JSON(response.result.value!)["drinks"].array {
                    for jsonDrink in drinkArray {
                        drinks.append(DrinkModel(json: jsonDrink))
                    }
                    callback!(drinks)
                }
            } else if response.result.isFailure {
                print("Request failed (filterByIngredient): " + response.result.error.debugDescription)
                return
            }
        }
    }
    
    static func getRandomDrinks(total: Int, callback: (([DrinkModel]) -> Void)?) {
        var drinks: [DrinkModel] = []
        
        for index in 1...total {
            getRandomDrink(callback: { drink in
                drinks.append(drink)
                print("\(index). \(drink.name)")
                if drinks.count == total {
                    callback!(drinks)
                }
            })
        }
    }
    
    static func getRandomDrink(callback: ((DrinkModel) -> Void)?) {
        Alamofire.request("\(API_URL)/random.php").responseJSON { response in
            if response.result.isSuccess {
                if let drinkJson = JSON(response.result.value!)["drinks"].array?.first {
                    let drink = DrinkModel(json: drinkJson)
                    callback!(drink)
                }
            } else if response.result.isFailure {
                print("Request failed (getRandomDrink): " + response.result.error.debugDescription)
                return
            }
        }
    }
    
    static func getDrinkById(id: String, callback: ((DrinkModel) -> Void)?) {
        Alamofire.request("\(API_URL)/lookup.php?i=\(id)").responseJSON { response in
            if response.result.isSuccess {
                if let drinkJson = JSON(response.result.value!)["drinks"].array?.first {
                    let drink = DrinkModel(json: drinkJson)
                    callback!(drink)
                }
            } else if response.result.isFailure {
                print("Request failed (getDrinkById): " + response.result.error.debugDescription)
                return
            }
        }
    }
}
