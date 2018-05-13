//
//  DrinkDetailViewController.swift
//  Bartinder
//
//  Created by Jason Kumar on 10.05.18.
//  Copyright © 2018 Bartinder. All rights reserved.
//

import Foundation
import SnapKit
import Alamofire
import SwiftyJSON

class DrinkDetailViewController: BaseViewController
{
    // MARK: Properties
    
    var scrollView = UIScrollView()
    var contentView = UIView()
    var imgViewDrink = UIImageView()
    var lblInstructions = UILabel()
    var txtInstructions = UILabel()
    var lblIngredients = UILabel()
    var stackIngredients = UIStackView()
    
    var drink: DrinkModel!
    var isError = false
    var isLoading = false
    
    
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
        
        title = drink.name.uppercased()
        
        // TODO: Make top bar invisible
        
        setupView()
        
        fetchData()
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
        
        
        // contentView
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        
        // imgViewDrink
        contentView.addSubview(imgViewDrink)
        imgViewDrink.snp.makeConstraints({ make in
            make.width.height.equalTo(view.frame.width)
            make.top.left.equalToSuperview()
        })
        imgViewDrink.contentMode = .scaleAspectFill
        imgViewDrink.kf.setImage(with: URL(string: drink.imgUrl))
        
        
        // lblInstructions
        contentView.addSubview(lblInstructions)
        lblInstructions.snp.makeConstraints({ make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(imgViewDrink.snp.bottom).offset(16)
        })
        lblInstructions.text = "INSTRUCTIONS"
        lblInstructions.textColor = .lightGray
        lblInstructions.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize, weight: .thin)
        
        
        // txtInstructions
        contentView.addSubview(txtInstructions)
        txtInstructions.snp.makeConstraints({ make in
            make.left.equalTo(lblInstructions).inset(4)
            make.top.equalTo(lblInstructions.snp.bottom).offset(4)
            make.right.equalToSuperview().inset(16)
        })
        txtInstructions.textColor = .darkGray
        txtInstructions.numberOfLines = 0
        
        
        // lblIngredients
        contentView.addSubview(lblIngredients)
        lblIngredients.snp.makeConstraints({ make in
            make.left.equalTo(lblInstructions)
            make.top.equalTo(txtInstructions.snp.bottom).offset(16)
        })
        lblIngredients.text = "INGREDIENTS"
        lblIngredients.textColor = .lightGray
        lblIngredients.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize, weight: .thin)
        
        
        // stackIngredients
        contentView.addSubview(stackIngredients)
        stackIngredients.snp.makeConstraints({ make in
            make.left.equalTo(txtInstructions)
            make.top.equalTo(lblIngredients.snp.bottom).offset(8)
            make.right.equalToSuperview().inset(16)
        })
        stackIngredients.axis = .vertical
        stackIngredients.spacing = 16
        
        
        // contentView
        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(stackIngredients).offset(24)
        }
    }
    
    
    // MARK: User Interaction
    
    
    // MARK: Additional Helpers
    
    func fetchData()
    {
        if isLoading
        {
            return
        }
        
        isLoading = true
        
        Alamofire.request("https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=\(drink.id)").responseJSON { response in
            response.result.ifSuccess {
                if let json = JSON(response.result.value!)["drinks"].array?.first
                {
                    self.updateDrink(DrinkModel(json: json))
                    
                    self.isError = false
                }
                
                self.isLoading = false
            }
            
            response.result.ifFailure {
                print("failure")
                self.isError = true
                self.isLoading = false
            }
        }
    }
    
    func updateDrink(_ drink: DrinkModel)
    {
        self.drink = drink
        
        imgViewDrink.kf.setImage(with: URL(string: drink.imgUrl))
        
        txtInstructions.text = drink.instructions
        
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
                make.left.equalToSuperview().inset(8)
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
    }
}
