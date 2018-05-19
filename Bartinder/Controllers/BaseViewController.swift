//
//  BaseController.swift
//  Bartinder
//
//  Created by Jason Kumar on 10.05.18.
//  Copyright © 2018 Bartinder. All rights reserved.
//

import Foundation
import UIKit
import FirebaseUI

class BaseViewController: UIViewController, FUIAuthDelegate
{
    // MARK: Properties
    
    var navBarBackgroundImage: UIImage?
    var navBarShadowImage: UIImage?
    var navBarBackgroundColor: UIColor?
    var navBarTintColor: UIColor?
    
    // Auth Vars
    fileprivate var authStateDidChangeHandle: AuthStateDidChangeListenerHandle?
    fileprivate(set) var auth: Auth? = Auth.auth()
    fileprivate(set) var authUI: FUIAuth? = FUIAuth.defaultAuthUI()
    let providers: [FUIAuthProvider] = [
        FUIGoogleAuth()
    ]
    
    public var userId: String? {
        return auth?.currentUser?.uid
    }
    
    
    // MARK: View Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        UIApplication.shared.statusBarStyle = .default
        
        // Restore navBar
        let navBar = navigationController?.navigationBar
        
        navBar?.setBackgroundImage(navBarBackgroundImage, for: .default)
        navBar?.shadowImage = navBarShadowImage
        navBar?.backgroundColor = navBarBackgroundColor
        navBar?.tintColor = navBarTintColor
        
        self.authStateDidChangeHandle = self.auth?.addStateDidChangeListener({ (auth, user) in
            // user is signed out
            if user == nil {
                self.authUI?.providers = self.providers
                let authViewController = self.authUI!.authViewController()
                
                self.present(authViewController, animated: true, completion: nil)
            } else {
                // user is signed in
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        // Save navBar
        let navBar = navigationController?.navigationBar
        
        navBarBackgroundImage = navBar?.backgroundImage(for: .default)
        navBarShadowImage = navBar?.shadowImage
        navBarBackgroundColor = navBar?.backgroundColor
        navBarTintColor = navBar?.tintColor
        
        if let handle = self.authStateDidChangeHandle {
            self.auth?.removeStateDidChangeListener(handle)
        }
    }
}
