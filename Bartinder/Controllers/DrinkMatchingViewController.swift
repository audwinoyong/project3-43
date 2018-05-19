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
import Firebase

class DrinkMatchingViewController: BaseViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate
{
    // MARK: Properties
    
    var pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    var btnLeft = UIButton()
    var btnRight = UIButton()
    var saveDrink = UIButton()
    
    var ingredient: String!
    var drinkVCs = [DrinkCellController]()
    var isError = false
    var isLoading = false
    var imgLeft = UIImage(named: "Arrow_Left")
    var imgRight = UIImage(named: "Arrow_Right")
    
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
        
        title = ingredient.uppercased()
        
        view.backgroundColor = .lightGray
        
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
    
    
    // MARK: Layout
    
    func setupView()
    {
        // saveDrink
        view.addSubview(saveDrink)
        saveDrink.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottomMargin)
            make.centerX.equalTo(view.snp.centerX)
            make.height.equalTo(64)
        }
        saveDrink.setTitle("Save", for: .normal)
        saveDrink.setTitleColor(UIColor.black, for: .normal)
        saveDrink.backgroundColor = .white
        saveDrink.addTarget(self, action: #selector(onSaveBtnTapped), for: .touchUpInside)
        
        // btnLeft
        view.addSubview(btnLeft)
        btnLeft.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottomMargin)
            make.left.equalToSuperview()
            make.right.equalTo(saveDrink.snp.left)
            make.height.equalTo(64)
        }
        btnLeft.contentEdgeInsets = UIEdgeInsetsMake(16, 16, 16, 16)
        btnLeft.imageView?.contentMode = .scaleAspectFit
        btnLeft.setImage(imgLeft, for: .normal)
        btnLeft.tintColor = .darkGray
        btnLeft.backgroundColor = .white
        btnLeft.addTarget(self, action: #selector(onBtnLeftTapped), for: .touchUpInside)
        btnLeft.isEnabled = false
        
        
        // btnRight
        view.addSubview(btnRight)
        btnRight.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottomMargin)
            make.right.equalToSuperview()
            make.left.equalTo(saveDrink.snp.right)
            make.height.equalTo(64)
        }
        btnRight.contentEdgeInsets = UIEdgeInsetsMake(16, 16, 16, 16)
        btnRight.imageView?.contentMode = .scaleAspectFit
        btnRight.setImage(imgRight, for: .normal)
        btnRight.tintColor = .darkGray
        btnRight.backgroundColor = .white
        btnRight.addTarget(self, action: #selector(onBtnRightTapped), for: .touchUpInside)
        btnRight.isEnabled = false
        
        
        // pageViewController
        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.view.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().inset(LayoutHelper.statusBarHeight + 44) // Don't use navBar height because it is messed up by SearchController
            make.bottom.equalTo(btnLeft.snp.top)
        }
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.didMove(toParentViewController: self)
    }
    
    
    // MARK: User Interaction
    
    @objc func onDrinkTapped()
    {
        if let drinkVC = pageViewController.viewControllers?.first as? DrinkCellController, let drink = drinkVC.getDrink()
        {
            navigationController?.pushViewController(DrinkDetailViewController(drink: drink), animated: true)
        }
    }
    
    @objc func onBtnLeftTapped()
    {
        // Find current index
        if let currentVC = pageViewController.viewControllers?.first as? DrinkCellController, let index = drinkVCs.index(of: currentVC)
        {
            // Set previous vc
            pageViewController.setViewControllers([drinkVCs[index - 1]], direction: .reverse, animated: true, completion: { _ in self.updateButtons() })
        }
    }
    
    @objc func onBtnRightTapped()
    {
        // Find current index
        if let currentVC = pageViewController.viewControllers?.first as? DrinkCellController, let index = drinkVCs.index(of: currentVC)
        {
            // Set next vc
            pageViewController.setViewControllers([drinkVCs[index + 1]], direction: .forward, animated: true, completion: { _ in self.updateButtons() })
        }
    }
    
    @objc func onSaveBtnTapped() {
        if let drinkController = pageViewController.viewControllers?.first as? DrinkCellController, let uid = userId {
            let drink = drinkController.getDrink()!
            drinkService.saveDrinkFor(userId: uid, drink)
        }
    }
    
    
    // MARK: UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        if let drinkCellController = viewController as? DrinkCellController, let index = drinkVCs.index(of: drinkCellController), index > 0
        {
            return drinkVCs[index - 1]
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        if let drinkCellController = viewController as? DrinkCellController, let index = drinkVCs.index(of: drinkCellController), index < (drinkVCs.count - 1)
        {
            return drinkVCs[index + 1]
        }
        
        return nil
    }

    
    // MARK: UIPageViewControllerDelegate
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {
        updateButtons()
    }
    
    
    // MARK: Additional Helpers
    
    func fetchData()
    {
        if isLoading
        {
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
                        let drinkVC = DrinkCellController()
                        
                        drinkVC.setDrink(drinkModel)
                        drinkVC.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onDrinkTapped)))
                        
                        self.drinkVCs.append(drinkVC)
                    }
                    
                    if let first = self.drinkVCs.first
                    {
                        self.pageViewController.setViewControllers([first], direction: .forward, animated: true, completion: { _ in self.updateButtons() })
                    }
                }
                
                self.isLoading = false
            }
            
            response.result.ifFailure
            {
                print("failure")
                self.isError = true
                self.isLoading = false
                self.updateButtons()
            }
        }
    }
    
    func updateButtons()
    {
        // Find current index of drinks
        if let currentVC = pageViewController.viewControllers?.first as? DrinkCellController, let index = drinkVCs.index(of: currentVC)
        {
            // Enable or disable buttons
            btnLeft.isEnabled = index > 0
            btnRight.isEnabled = index < drinkVCs.count - 1
        }
        else
        {
            btnLeft.isEnabled = false
            btnRight.isEnabled = false
        }
    }
}
