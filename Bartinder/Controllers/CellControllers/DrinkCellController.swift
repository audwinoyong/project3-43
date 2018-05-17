//
//  DrinkCellController.swift
//  Bartinder
//
//  Created by Jason Kumar on 12.05.18.
//  Copyright © 2018 Bartinder. All rights reserved.
//

import Foundation
import SnapKit
import Kingfisher

class DrinkCellController: UIViewController // We don't want a white background here
{
    // MARK: Properties
    
    var lytContainer = UIView()
    var imgViewDrink = UIImageView()
    var lytBottom = UIView()
    var lblTitle = UILabel()
    
    private var drink: DrinkModel?
    let imgPlaceholder = UIImage(named: "Cocktail")
    
    
    // MARK: View Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupView()
    }
    
    
    // MARK: Layout
    
    func setupView()
    {
        // lytContainer
        view.addSubview(lytContainer)
        lytContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(24)
        }
        lytContainer.backgroundColor = .white
        lytContainer.clipsToBounds = true
        lytContainer.layer.cornerRadius = 16
        
        
        // imgViewDrink
        lytContainer.addSubview(imgViewDrink)
        imgViewDrink.snp.makeConstraints({ make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(lytContainer.snp.width)
        })
        imgViewDrink.contentMode = .scaleAspectFill
        imgViewDrink.tintColor = .lightGray
        imgViewDrink.image = imgPlaceholder
        
        
        // lytBottom
        lytContainer.addSubview(lytBottom)
        lytBottom.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(imgViewDrink.snp.bottom)
        }
        
        // lblTitle
        lytBottom.addSubview(lblTitle)
        lblTitle.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        lblTitle.font = UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: .heavy)
    }
    
    
    // Additional Helpers
    
    func getDrink() -> DrinkModel?
    {
        return drink
    }
    
    func setDrink(_ drink: DrinkModel?)
    {
        self.drink = drink
        
        if let drink = drink
        {
            imgViewDrink.kf.setImage(with: URL(string: drink.imgUrl), placeholder: imgPlaceholder)
            lblTitle.text = drink.name.uppercased()
        }
        else
        {
            imgViewDrink.image = imgPlaceholder
            lblTitle.text = ""
        }
    }
}
