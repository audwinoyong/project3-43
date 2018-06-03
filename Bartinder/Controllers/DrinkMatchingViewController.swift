//
//  DrinkMatchingViewController.swift
//  Bartinder
//
//  Created by Jason Kumar on 10.05.18.
//  Copyright © 2018 Bartinder. All rights reserved.
//

import Foundation
import SnapKit
import SwiftyJSON
import ZLSwipeableViewSwift
import Toast_Swift

class DrinkMatchingViewController: BaseViewController
{
    // MARK: Properties
    let numLoad = 10
    let maxDistance = 5
    var timesLoaded = 0
    var loadBuffer: Int {
        return drinks.count + Int(swipeableView.numberOfActiveView)
    }
    
    var swipeableView = ZLSwipeableView()
    var drinkService: DrinkService!
    
    var drinks = [DrinkModel]()
    
    // MARK: Lifecycle
    
    init()
    {
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
        fetchData(discardViews: true)
        setupView()
        
        
        // Present tutorial above everything
        if !UserDefaultsHelper.getHasSeenTutorial()
        {
            let tutorialVC = TutorialViewController()
            
            providesPresentationContextTransitionStyle = true
            definesPresentationContext = true
            tutorialVC.modalPresentationStyle = .overFullScreen
            
            navigationController?.present(tutorialVC, animated: false, completion: nil)
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
            make.bottom.equalToSuperview().inset(32 + LayoutHelper.getTabBarHeight(for: self))
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
                if let drinkView = view as? DrinkCardView, let drink = drinkView.getDrink() {
                    self.addDrinkToFavorites(drink)
                }
                break
            default:
                break
            }
            
            print("Drinks left \(self.drinks.count). Calc Buffer \(self.drinks.count + 3). Buffer \(self.loadBuffer)")
            if self.loadBuffer < self.maxDistance {
                print("Buffer is less than \(self.maxDistance). Fetching data")
                self.fetchData(discardViews: false)
            }
        }
    }
    
    func addDrinkToFavorites(_ drink: DrinkModel) {
        if let uid = userId {
            drinkService.saveDrinkFor(userId: uid, drink)
            self.view.makeToast("Added to favorites", duration: 1.0, position: .bottom)
        }
    }
    
    
    // MARK: User Interaction
    @objc func signOut(_ sender: UIView) {
        do {
            try self.authUI?.signOut()
        } catch {
            // show error message
            print("error signing out")
        }
    }
    
    @objc func onDrinkTapped(view: UIView) {
        if let drinkView = view as? DrinkCardView, let drink = drinkView.getDrink() {
            navigationController?.pushViewController(DrinkDetailViewController(drinkId: drink.id), animated: true)
        }
    }
    
    
    // MARK: Additional Helpers
    
    func fetchData(discardViews: Bool)
    {
        DrinkAPI.getRandomDrinks(total: numLoad, callback: { data in
            print("drink count: \(data.count)")
            self.timesLoaded += 1
            self.updateViews(data: data, discardViews: discardViews)
        })
    }
    
    func updateViews(data: [DrinkModel], discardViews: Bool)
    {
        drinks.append(contentsOf: data)
        if discardViews {
            swipeableView.discardViews()
        }
        swipeableView.loadViews()
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
