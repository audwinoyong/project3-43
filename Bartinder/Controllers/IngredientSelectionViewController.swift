//
//  ViewController.swift
//  Bartinder
//
//  Created by Jason Kumar on 10.05.18.
//  Copyright © 2018 Bartinder. All rights reserved.
//

import SnapKit
import Alamofire
import SwiftyJSON

class IngredientSelectionViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource
{
    // MARK: Properties
    
    var tableView = UITableView()
    
    var ingredients = [String]()
    var isError = false
    var isEmpty = false
    var isLoading = false
    
    
    // MARK: View Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        title = "Ingredient Selection"
        
        setupView()
        
        fetchData()
    }
    
    
    // MARK: Layout
    
    func setupView()
    {
        // tableView
        view.addSubview(tableView)
        tableView.snp.makeConstraints({ make in
            make.size.equalToSuperview()
        })
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 54
    }
    
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let ingredient = ingredients[indexPath.row]
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell")
        
        if cell == nil
        {
            cell = UITableViewCell(style: .default, reuseIdentifier: "IngredientCell")
        }
        
        cell!.selectionStyle = .none
        cell!.textLabel?.text = ingredient
        
        return cell!
    }
    
    
    // MARK: Additional Helpers
    
    func fetchData()
    {
        if isLoading
        {
            return
        }
        
        isLoading = true
        
        Alamofire.request("https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list").responseJSON { response in
            response.result.ifSuccess
            {
                if let jsonArray = JSON(response.result.value!)["drinks"].array
                {
                    for ingredient in jsonArray
                    {
                        self.ingredients.append(ingredient["strIngredient1"].string!)
                    }
                    
                    DispatchQueue.main.async
                    {
                        self.tableView.reloadData()
                    }
                }
                
                self.isLoading = false
            }
            
            response.result.ifFailure
            {
                print("failure")
                self.isError = true
                self.isEmpty = false
                self.isLoading = false
            }
        }
    }
}
