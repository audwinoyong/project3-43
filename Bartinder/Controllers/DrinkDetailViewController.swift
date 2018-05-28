//
//  DrinkDetailViewController.swift
//  Bartinder
//
//  Created by Jason Kumar on 10.05.18.
//  Copyright © 2018 Bartinder. All rights reserved.
//

import Foundation
import SnapKit
import SwiftyJSON

class DrinkDetailViewController: BaseViewController, UIScrollViewDelegate
{
    // MARK: Properties
    
    var gradientView = UIView()
    
    var scrollView = UIScrollView()
    var contentView = UIView()
    
    var lytImgContainer = UIView()
    var imgViewDrink = UIImageView()
    var lytDrinkInfo = UIView()
    var lblDrinkTitle = UILabel()
    var lblDrinkAlcoholicType = UILabel()
    
    var lblInstructions = UILabel()
    var txtInstructions = UILabel()
    var lblIngredients = UILabel()
    var stackIngredients = UIStackView()
    
    var drink: DrinkModel!
    let imgPlaceholder = UIImage(named: "Cocktail")
    var blurImageProcessor: ALDBlurImageProcessor?
    
    // MARK: Lifecycle
    
    init(drink: DrinkModel)
    {
        self.drink = drink
        
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
        
        setupView()
        
        updateImageBlur()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        // navBar
        let navBar = navigationController?.navigationBar
        navBarBackgroundImage = navBar?.backgroundImage(for: .default)
        navBar?.setBackgroundImage(UIImage(), for: .default)
        navBarShadowImage = navBar?.shadowImage
        navBar?.shadowImage = UIImage()
        navBarBackgroundColor = navBar?.backgroundColor
        navBar?.backgroundColor = nil
        navBarTintColor = navBar?.tintColor
        navBar?.tintColor = .white
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientView.bounds
        gradientLayer.colors = [
            UIColor(white: 0, alpha: 0.3).cgColor,
            UIColor(white: 0, alpha: 0).cgColor
        ]

        gradientView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    // MARK: Layout
    
    func setupView()
    {        
        // scrollView
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        scrollView.alwaysBounceVertical = true
        scrollView.delegate = self
        let insets = UIEdgeInsetsMake(-(LayoutHelper.statusBarHeight + (navigationController?.navigationBar.frame.height ?? 0)), 0, 0, 0)
        scrollView.contentInset = insets
        
        
        // contentView
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        
        // gradientView
        view.addSubview(gradientView)
        gradientView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(LayoutHelper.statusBarHeight + (navigationController?.navigationBar.frame.height ?? 0) + 8)
        }
        
        
        // lblInstructions
        contentView.addSubview(lblInstructions)
        lblInstructions.snp.makeConstraints({ make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(view.frame.width + 16)
        })
        lblInstructions.text = "INSTRUCTIONS"
        lblInstructions.textColor = .darkGray
        lblInstructions.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize, weight: .thin)
        
        
        // txtInstructions
        contentView.addSubview(txtInstructions)
        txtInstructions.snp.makeConstraints({ make in
            make.left.equalTo(lblInstructions).inset(16)
            make.top.equalTo(lblInstructions.snp.bottom).offset(4)
            make.right.equalToSuperview().inset(16)
        })
        txtInstructions.text = drink.instructions
        txtInstructions.numberOfLines = 0
        
        
        // lblIngredients
        contentView.addSubview(lblIngredients)
        lblIngredients.snp.makeConstraints({ make in
            make.left.equalTo(lblInstructions)
            make.top.equalTo(txtInstructions.snp.bottom).offset(16)
        })
        lblIngredients.text = "INGREDIENTS"
        lblIngredients.textColor = .darkGray
        lblIngredients.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize, weight: .thin)
        
        
        // stackIngredients
        contentView.addSubview(stackIngredients)
        stackIngredients.snp.makeConstraints({ make in
            make.left.right.equalTo(txtInstructions)
            make.top.equalTo(lblIngredients.snp.bottom).offset(8)
        })
        stackIngredients.axis = .vertical
        stackIngredients.spacing = 16
        for subview in stackIngredients.arrangedSubviews
        {
            stackIngredients.removeArrangedSubview(subview)
        }
        
        for (ingredient, measurement) in drink.ingredientsAndMeasurements
        {
            let subview = UIView()
            
            // imgIngredient
            let imgIngredient = UIImageView()
            subview.addSubview(imgIngredient)
            imgIngredient.snp.makeConstraints { make in
                make.width.height.equalTo(40)
                make.top.bottom.equalToSuperview()
                make.left.equalToSuperview()
            }
            imgIngredient.clipsToBounds = true
            imgIngredient.layer.cornerRadius = 20
            imgIngredient.contentMode = .scaleAspectFit
            imgIngredient.backgroundColor = .lightGray
            let safeIng = ingredient.replacingOccurrences(of: " ", with: "%20")
            imgIngredient.kf.setImage(with: URL(string: "https://www.thecocktaildb.com/images/ingredients/\(safeIng)-Small.png"))
            
            
            // lblIngredient
            let lblIngredient = UILabel()
            subview.addSubview(lblIngredient)
            lblIngredient.snp.makeConstraints { make in
                make.left.equalTo(imgIngredient.snp.right).offset(16)
                make.centerY.equalToSuperview()
            }
            lblIngredient.text = ingredient
            
            
            // lblMeasurement
            let lblMeasurement = UILabel()
            subview.addSubview(lblMeasurement)
            lblMeasurement.snp.makeConstraints { make in
                make.right.equalToSuperview().inset(16)
                make.centerY.equalToSuperview()
            }
            lblMeasurement.text = measurement
            
            
            stackIngredients.addArrangedSubview(subview)
        }
        
        
        // lytImgContainer
        contentView.addSubview(lytImgContainer)
        lytImgContainer.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(lytImgContainer.snp.width).priority(.required)
            make.bottom.greaterThanOrEqualTo(view.snp.top).offset(LayoutHelper.statusBarHeight + (navigationController?.navigationBar.frame.height ?? 0) + 40).priority(.required)
        }
        
        
        // imgViewDrink
        contentView.addSubview(imgViewDrink)
        imgViewDrink.snp.makeConstraints({ make in
            make.left.right.bottom.equalTo(lytImgContainer)
            make.top.equalTo(view).priority(.high)
            make.height.greaterThanOrEqualTo(lytImgContainer).priority(.required)
        })
        imgViewDrink.contentMode = .scaleAspectFill
        imgViewDrink.tintColor = .lightGray
        imgViewDrink.kf.setImage(with: URL(string: drink.imgUrl), placeholder: imgPlaceholder, completionHandler: { (image, _, _, _) in
            self.onImageDrinkChanged(to: image)
        })
        
        
        // lytDrinkInfo
        imgViewDrink.addSubview(lytDrinkInfo)
        lytDrinkInfo.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(40)
        }
        lytDrinkInfo.backgroundColor = UIColor(white: 0, alpha: 0.3)
        
        
        // lblDrinkTitle
        lytDrinkInfo.addSubview(lblDrinkTitle)
        lblDrinkTitle.snp.makeConstraints({ make in
            make.left.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        })
        lblDrinkTitle.text = drink.name
        lblDrinkTitle.textColor = .white
        
        
        // lblDrinkAlcoholicType
        lytDrinkInfo.addSubview(lblDrinkAlcoholicType)
        lblDrinkAlcoholicType.snp.makeConstraints({ make in
            make.right.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        })
        lblDrinkAlcoholicType.text = drink.alcoholicType.lowercased()
        lblDrinkAlcoholicType.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize, weight: .light)
        lblDrinkAlcoholicType.textColor = .white
        
        
        // contentView
        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(stackIngredients).offset(24)
        }
    }
    
    func updateImageBlur()
    {
        let scrollOffset = scrollView.contentOffset.y
        
        // Image is square -> normal header height = frame.width
        let normalHeaderHeight = view.frame.width
        
        // Blur image when scrolling
        // scrollOffset = 0 -> no blur
        // scrollOffset = normalHeaderHeight -> max blur
        let blurValue = max(min(scrollOffset / normalHeaderHeight, 1), 0)
        
        if let blurImageProcessor = blurImageProcessor
        {
            blurImageProcessor.asyncBlur(withRadius: UInt32(blurValue * 39), iterations: 3, cancelingLastOperation: true, successBlock: { image in
                self.imgViewDrink.image = image
            }, errorBlock: { _ in })
        }
    }
    
    
    // MARK: User Interaction
    
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        updateImageBlur()
    }
    
    
    // MARK: Additional Helpers
    
    func onImageDrinkChanged(to image: UIImage?)
    {
        blurImageProcessor = ALDBlurImageProcessor(image: image)
    }
}
