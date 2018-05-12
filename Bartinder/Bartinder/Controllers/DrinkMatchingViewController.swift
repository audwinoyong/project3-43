//
//  DrinkMatchingViewController.swift
//  Bartinder
//
//  Created by Jason Kumar on 10.05.18.
//  Copyright © 2018 Bartinder. All rights reserved.
//

import Foundation
import SnapKit
import Alamofire
import SwiftyJSON

class DrinkMatchingViewController: BaseViewController
{
    // MARK: Properties
    
    var displayedDrink = DrinkCellController()
    var offScreenDrink = DrinkCellController()
    
    var ingredient: String!
    var drinks = [DrinkModel]()
    var isError = false
    var isLoading = false
    
    
    // MARK: Lifecycle
    
    init(ingredient: String)
    {
        self.ingredient = ingredient
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: View Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        title = ingredient.uppercased()
        
        view.backgroundColor = .lightGray
        
        setupView()
        
        fetchData()
    }
    
    
    // MARK: Layout
    
    func setupView()
    {
        // displayedDrink
        addChildViewController(displayedDrink)
        view.addSubview(displayedDrink.view)
        displayedDrink.didMove(toParentViewController: self)
    }
    
    
    // MARK: User Interaction
    
    
    // MARK: Additional Helpers
    
    func fetchData()
    {
        if isLoading
        {
            return
        }
        
        isLoading = true
        
        let safeIng = ingredient.replacingOccurrences(of: " ", with: "_")
        
        Alamofire.request("https://www.thecocktaildb.com/api/json/v1/1/filter.php?i=\(safeIng)").responseJSON { response in
            response.result.ifSuccess
            {
                if let jsonArray = JSON(response.result.value!)["drinks"].array
                {
                    for drink in jsonArray
                    {
                        //print(drink)
                        self.drinks.append(DrinkModel(json: drink))
                    }
                }
                
                if let firstDrink = self.drinks.first
                {
                    self.displayedDrink.setDrink(firstDrink)
                }
                
                self.isLoading = false
            }
            
            response.result.ifFailure
            {
                print("failure")
                self.isError = true
                self.isLoading = false
            }
        }
    }
}
