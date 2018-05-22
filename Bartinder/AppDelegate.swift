//
//  AppDelegate.swift
//  Bartinder
//
//  Created by Jason Kumar on 10.05.18.
//  Copyright © 2018 Bartinder. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .white
        
        
        let screen1 = FavoritesViewController()
        screen1.title = "Favorites"
        screen1.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        
        let screen2 = DrinkMatchingViewController(ingredient: "Gin")
        screen2.title = "Drinks"
        screen2.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 1)
//        let cocktailImage = UIImage(named: "Cocktail")
//        screen2.tabBarItem = UITabBarItem(title: "Match", image: UIImage(named: "Cocktail"), tag: 1)
        
//        var drink = DrinkModel()
//        drink.id = "16134"
//        drink.name = "Drink 1"
//        drink.imgUrl = "https://www.thecocktaildb.com/images/media/drink/yvxrwv1472669728.jpg"
//        let screen3 = DrinkDetailViewController(drink: drink)
//        screen3.title = "Drink Detail"
//        screen3.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 2)
        
        
        let screen3 = FriendsViewController()
        screen3.title = "Friends"
        screen3.tabBarItem = UITabBarItem(title: "Friends", image: UIImage(named: "People"), tag: 2)
        
        
        let controllers = [screen1, screen2, screen3]
        let tabController = UITabBarController()
        tabController.viewControllers = controllers.map {
            UINavigationController(rootViewController: $0)
        }
        tabController.selectedIndex = 1
        self.window?.rootViewController = tabController
        
//        self.window?.rootViewController = UINavigationController(rootViewController: IngredientSelectionViewController())
        
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool
    {
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?
        
        return self.handleOpenUrl(url, sourceApplication: sourceApplication)
    }
    
    func handleOpenUrl(_ url: URL, sourceApplication: String?) -> Bool
    {
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false
        {
            return true
        }
        
        // other URL handling goes here.
        return false
    }

    func applicationWillResignActive(_ application: UIApplication)
    {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication)
    {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication)
    {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication)
    {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication)
    {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

