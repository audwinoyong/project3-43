//
//  BaseController.swift
//  Bartinder
//
//  Created by Jason Kumar on 10.05.18.
//  Copyright © 2018 Bartinder. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController
{
    // MARK: Properties
    
    var navBarBackgroundImage: UIImage?
    var navBarShadowImage: UIImage?
    var navBarBackgroundColor: UIColor?
    var navBarTintColor: UIColor?
    
    
    // MARK: View Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.backgroundColor = .white
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
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        // Save navBar
        let navBar = navigationController?.navigationBar
        
        navBarBackgroundImage = navBar?.backgroundImage(for: .default)
        navBarShadowImage = navBar?.shadowImage
        navBarBackgroundColor = navBar?.backgroundColor
        navBarTintColor = navBar?.tintColor
    }
}
