//
//  FavoritesViewController.swift
//  Bartinder
//
//  Created by Andreas Lengkeek on 20/5/18.
//  Copyright © 2018 Bartinder. All rights reserved.
//

import UIKit

class FavoritesViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var drinks: [DrinkModel]
    var drinkService: DrinkService
    var tableView = UITableView()
    var friendUserId: String?
    
    init(friendId: String? = nil) {
        drinks = []
        drinkService = DrinkService()
        
        friendUserId = friendId
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        drinks = []
        drinkService = DrinkService()
        
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()

        // Do any additional setup after loading the view.
        // get drinks from firebase
        let uid = friendUserId == nil ? userId : friendUserId
        
        if let uid = uid {
            drinkService.getDrinksFor(userId: uid, callback: { result in
                self.drinks = result
                self.tableView.reloadData()
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView() {
        // tableView
        view.addSubview(tableView)
        tableView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let drink = drinks[indexPath.row]
        
        let cell = UITableViewCell()
        cell.textLabel?.text = drink.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let drink = drinks[indexPath.row]
        
        navigationController?.pushViewController(DrinkDetailViewController(drink: drink), animated: true)
    }
}
