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

class IngredientSelectionViewController: BaseViewController, UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource, FUIAuthDelegate
{
    // MARK: Properties
    
    var searchController = UISearchController(searchResultsController: nil)
    var tableView = UITableView()
    var refreshControl = UIRefreshControl()
    
    var ingredients = [String]()
    var filteredIngredients = [String]()
    var isError = false
    var isEmpty = false
    var isLoading = false
    var isKeyboardShown: Bool!
    
    // Auth Vars
    fileprivate var authStateDidChangeHandle: AuthStateDidChangeListenerHandle?
    fileprivate(set) var auth: Auth? = Auth.auth()
    fileprivate(set) var authUI: FUIAuth? = FUIAuth.defaultAuthUI()
    let providers: [FUIAuthProvider] = [
        FUIGoogleAuth()
    ]
    
    
    // MARK: View Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        
        setupView()
        
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        
        isKeyboardShown = false
        
        self.authStateDidChangeHandle = self.auth?.addStateDidChangeListener({ (auth, user) in
            // user is signed out
            if user == nil
            {
                self.authUI?.providers = self.providers
                let authViewController = self.authUI!.authViewController()
                
                self.present(authViewController, animated: true, completion: nil)
            }
            else
            {
                // user is signed in
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        // Hides keyboard
        view.endEditing(true)
        
        NotificationCenter.default.removeObserver(self)
        
        if let handle = self.authStateDidChangeHandle
        {
            self.auth?.removeStateDidChangeListener(handle)
        }
    }
    
    
    // MARK: Layout
    
    func setupView()
    {
        // searchController
        navigationItem.titleView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Filter ingredients..."
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
        tableView.keyboardDismissMode = .interactive
        tableView.register(ErrorCellController.self, forCellReuseIdentifier: NSStringFromClass(ErrorCellController.self))
        
        // refreshControl
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        
        
        // signOutButton
        let signOutButton = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(self.signOut))
        self.navigationItem.rightBarButtonItem = signOutButton
    }
    
    
    // MARK: User Interaction
    
    @objc func signOut(_ sender: UIView)
    {
        do
        {
            try self.authUI?.signOut()
        }
        catch
        {
            // show error message
        }
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
                filteredIngredients = ingredients
            }
            else
            {
                filteredIngredients = ingredients.filter { ingredient in
                    ingredient.lowercased().contains(searchText.lowercased())
                }
            }
        }
        else
        {
            filteredIngredients = ingredients
        }
        
        tableView.reloadData()
    }
    
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        guard !isError else
        {
            return view.frame.height - (navigationController?.navigationBar.frame.height ?? 0) - LayoutHelper.statusBarHeight
        }
        
        return 54
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let ingredient = filteredIngredients[indexPath.row]
        
        navigationController?.pushViewController(DrinkMatchingViewController(ingredient: ingredient), animated: true)
    }
    
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        guard !isError else
        {
            return 1
        }
        
        return filteredIngredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard !isError else
        {
            tableView.separatorStyle = .none
            
            return tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(ErrorCellController.self), for: indexPath)
        }
        
        tableView.separatorStyle = .singleLine
        
        let ingredient = filteredIngredients[indexPath.row]
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell")
        
        if cell == nil
        {
            cell = UITableViewCell(style: .default, reuseIdentifier: "IngredientCell")
        }
        
        cell!.textLabel?.text = ingredient
        
        return cell!
    }
    
    
    // MARK: Additional Helpers
    
    @objc func fetchData()
    {
        if isLoading
        {
            return
        }
        
        // Reset everything data related
        isLoading = true
        isError = false
        isEmpty = false
        refreshControl.isEnabled = false
        ingredients = [String]()
        filteredIngredients = [String]()
        searchController.searchBar.text = ""
        tableView.reloadData()
        
        // Start fetching data
        Alamofire.request("https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list").responseJSON { response in
            response.result.ifSuccess
            {
                if let jsonArray = JSON(response.result.value!)["drinks"].array
                {
                    for ingredient in jsonArray
                    {
                        let newIngredient = ingredient["strIngredient1"].string!
                        
                        self.ingredients.append(newIngredient)
                        self.filteredIngredients.append(newIngredient)
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                
                self.isLoading = false
                self.refreshControl.isEnabled = true
                self.refreshControl.endRefreshing()
            }
            
            response.result.ifFailure
            {
                self.isError = true
                self.isLoading = false
                self.refreshControl.isEnabled = true
                self.refreshControl.endRefreshing()
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification)
    {
        guard !isKeyboardShown else
        {
            return;
        }
        
        isKeyboardShown = true
        
        let keyboardSize = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        
        // Update Scrollview insets
        var insets = tableView.contentInset
        
        insets.bottom = keyboardSize.height
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
    }
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
        guard isKeyboardShown else
        {
            return
        }
        
        isKeyboardShown = false
        
        // Update Scrollview insets
        tableView.contentInset = .zero
        tableView.scrollIndicatorInsets = .zero
    }
}
