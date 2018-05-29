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
import ZLSwipeableViewSwift

class DrinkMatchingViewController: BaseViewController
{
    // MARK: Properties
    
    var swipeableView = ZLSwipeableView()
    
    var ingredient: String!
    var drinks = [DrinkModel]()
    var isError = false
    var isLoading = false
    
    var drinkService: DrinkService!
    
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
        
        drinkService = DrinkService()
        setupView()
        fetchData()
        
        
        // Present tutorial above everything
        if !UserDefaultsHelper.getHasSeenTutorial()
        {
            let tutorialVC = TutorialViewController()
            
            providesPresentationContextTransitionStyle = true
            definesPresentationContext = true
            tutorialVC.modalPresentationStyle = .overCurrentContext
            
            navigationController?.present(tutorialVC, animated: true, completion: nil)
        }
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        swipeableView.nextView = { return self.nextCardView() }
    }
    
    
    // MARK: Layout
    
    func setupView()
    {
        // swipeableView
        view.addSubview(swipeableView)
        swipeableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.top.equalToSuperview().inset(LayoutHelper.statusBarHeight + (navigationController?.navigationBar.frame.height ?? 0) + 32) // If SearchController messes navBar height up, simply use 44
            make.bottom.equalToSuperview().inset((tabBarController?.tabBar.frame.height ?? 0) + 32)
        }
        swipeableView.allowedDirection = .Horizontal
        swipeableView.numberOfActiveView = 3
        swipeableView.didTap = {view, _ in
            self.onDrinkTapped(view: view)
        }
        
        // signOutButton
        let signOutButton = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(self.signOut))
        self.navigationItem.rightBarButtonItem = signOutButton
        
        swipeableView.didSwipe = {view, direction, vector in
            switch direction {
            case .Right:
                let drinkView = view as! DrinkCardView
                self.addDrinkToFavorites(drinkView.getDrink()!)
                break
            default:
                break
            }
        }
    }
    
    func addDrinkToFavorites(_ drink: DrinkModel) {
        if let uid = userId {
            drinkService.saveDrinkFor(userId: uid, drink)
        }
    }
    
    
    // MARK: User Interaction
    @objc func signOut(_ sender: UIView) {
        do {
            try self.authUI?.signOut()
        } catch {
            // show error message
        }
    }
    
    @objc func onDrinkTapped(view: UIView) {
        if let drinkView = view as? DrinkCardView, let drink = drinkView.getDrink() {
            navigationController?.pushViewController(DrinkDetailViewController(drink: drink), animated: true)
        }
    }
    
    
    // MARK: Additional Helpers
    
    func fetchData() {
        if isLoading {
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
                        let drinkModel = DrinkModel(json: drink)
                        
                        self.drinks.append(drinkModel)
                    }
                    
                    self.swipeableView.discardViews()
                    self.swipeableView.loadViews()
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
    
    func nextCardView() -> UIView?
    {
        let cardView = DrinkCardView(frame: self.swipeableView.bounds)
        
        if !drinks.isEmpty
        {
            let model = drinks.remove(at: 0)
            cardView.setDrink(model)
        }
        else
        {
            cardView.setDrink(nil)
        }
        
        return cardView
    }
}
