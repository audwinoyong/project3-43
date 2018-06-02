//
//  FavoritesViewController.swift
//  Bartinder
//
//  Created by Andreas Lengkeek on 20/5/18.
//  Copyright © 2018 Bartinder. All rights reserved.
//

import UIKit

class FavoritesViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    // MARK: Properties
    
    var tableView = UITableView()
    var searchController = UISearchController(searchResultsController: nil)
    
    var drinks: [DrinkModel]
    var filteredDrinks: [DrinkModel]
    var drinkService: DrinkService
    var friendUserId: String?
    
    var isError = false
    var isLoading = false
    
    init(friendId: String? = nil) {
        drinks = []
        filteredDrinks = []
        drinkService = DrinkService()
        
        friendUserId = friendId
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        drinks = []
        filteredDrinks = []
        drinkService = DrinkService()
        
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // get drinks from firebase
        let uid = friendUserId == nil ? userId : friendUserId
        
        if let uid = uid {
            drinkService.getDrinksFor(userId: uid, callback: { result in
                self.drinks = result
                self.filteredDrinks = result
                self.tableView.reloadData()
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView() {
        navigationItem.title = "Favorites"
        
        // searchController
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search drinks..."
        searchController.searchBar.showsCancelButton = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false // If enabled, searchbar content disappears after search
        definesPresentationContext = true // ensures that the search bar doesn't remain on screen if the user navigates to another view controller while the UISearchController is active
        
        // tableView
        view.addSubview(tableView)
        tableView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredDrinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let drink = filteredDrinks[indexPath.row]
        
        let cell = UITableViewCell()
        cell.textLabel?.text = drink.name
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let drink = filteredDrinks[indexPath.row]
        
        navigationController?.pushViewController(DrinkDetailViewController(drinkId: drink.id), animated: true)
    }
    
    // MARK: UISearchControllerUpdating
    
    func updateSearchResults(for searchController: UISearchController)
    {
        guard !isLoading && !isError else
        {
            return
        }
        
        if let searchText = searchController.searchBar.text
        {
            if searchText.replacingOccurrences(of: " ", with: "").count == 0
            {
                filteredDrinks = drinks
            }
            else
            {
                filteredDrinks = drinks.filter({ $0.name.lowercased().contains(searchText.lowercased()) })
            }
        }
        else
        {
            filteredDrinks = drinks
        }
        
        tableView.reloadData()
    }
}
