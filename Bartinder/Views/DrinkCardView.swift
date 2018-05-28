//
//  DrinkCardView.swift
//  Bartinder
//
//  Created by Jason Kumar on 24.05.18.
//  Copyright © 2018 Bartinder. All rights reserved.
//

import Foundation
import SnapKit
import Kingfisher

class DrinkCardView: UIView
{
    // MARK: Properties
    
    var lytContainer = UIView()
    var imgViewDrink = UIImageView()
    var lytBottom = UIView()
    var lblTitle = UILabel()
    
    private var drink: DrinkModel?
    let imgPlaceholder = UIImage(named: "Cocktail_BigIcon")
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    func setupView()
    {
        // Container
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize(width: 0, height: 1.5)
        layer.shadowRadius = 4.0
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        
        
        // lytContainer
        addSubview(lytContainer)
        lytContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        lytContainer.backgroundColor = .white
        lytContainer.layer.cornerRadius = 16
        lytContainer.clipsToBounds = true
        
        
        // imgViewDrink
        lytContainer.addSubview(imgViewDrink)
        imgViewDrink.snp.makeConstraints({ make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(self.snp.width)
        })
        imgViewDrink.contentMode = .scaleAspectFill
        imgViewDrink.tintColor = .lightGray
        
        
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
    
    
    // MARK: Additional Helpers
    
    func getDrink() -> DrinkModel?
    {
        return drink
    }
    
    func setDrink(_ drink: DrinkModel?)
    {
        self.drink = drink
        
        guard let drink = drink else
        {
            imgViewDrink.image = imgPlaceholder
            lblTitle.text = ""
            
            return
        }
        
        imgViewDrink.kf.setImage(with: URL(string: drink.imgUrl), placeholder: imgPlaceholder)
        lblTitle.text = drink.name.uppercased()
    }
}
