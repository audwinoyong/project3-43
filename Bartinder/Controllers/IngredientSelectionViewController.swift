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
import Firebase
import FirebaseUI


class IngredientSelectionViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, FUIAuthDelegate
{
    // Auth Vars
    fileprivate var authStateDidChangeHandle: AuthStateDidChangeListenerHandle?
    fileprivate(set) var auth: Auth? = Auth.auth()
    fileprivate(set) var authUI: FUIAuth? = FUIAuth.defaultAuthUI()
    let providers: [FUIAuthProvider] = [
        FUIGoogleAuth()
    ]

    
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
        let authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        
        
        
        
        title = "Ingredient Selection"
        
        setupView()
        
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.authStateDidChangeHandle =
            self.auth?.addStateDidChangeListener({ (auth, user) in
                if user == nil {
                    // user is signed out
                    self.authUI?.providers = self.providers
                    let authViewController = self.authUI!.authViewController()
                    self.present(authViewController, animated: true, completion: nil)
                } else {
                    // user is signed in
                }
            })

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let handle = self.authStateDidChangeHandle {
            self.auth?.removeStateDidChangeListener(handle)
        }
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
        
        let signOutButton = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(self.signOut))
        self.navigationItem.rightBarButtonItem = signOutButton
    }
    
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 54
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let ingredient = ingredients[indexPath.row]
        
        navigationController?.pushViewController(DrinkMatchingViewController(ingredient: ingredient), animated: true)
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
        
        cell!.textLabel?.text = ingredient
        
        return cell!
    }
    
    @objc func signOut(_ sender: UIView) {
        do {
            try self.authUI?.signOut();
        } catch {
            // show error message
        }
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
