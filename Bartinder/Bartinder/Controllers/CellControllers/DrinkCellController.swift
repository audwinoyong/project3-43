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
    
    
    // MARK: View Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupView()
    }
    
    
    // MARK: Layout
    
    func setupView()
    {
        let topInset = LayoutHelper.statusBarHeight + (navigationController?.navigationBar.frame.height ?? 0)
        
        // lytContainer
        view.addSubview(lytContainer)
        lytContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(topInset + 24)
            make.bottom.equalToSuperview().inset(24)
        }
        lytContainer.backgroundColor = .white
        lytContainer.clipsToBounds = true
        lytContainer.layer.cornerRadius = 4
        
        
        // imgViewDrink
        lytContainer.addSubview(imgViewDrink)
        imgViewDrink.snp.makeConstraints({ make in
            make.width.height.equalTo(view.frame.width)
            make.top.left.equalToSuperview()
        })
        imgViewDrink.contentMode = .scaleAspectFill
        
        
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
    
    func setDrink(_ drink: DrinkModel)
    {
        imgViewDrink.kf.setImage(with: URL(string: drink.imgUrl))
        lblTitle.text = drink.name.uppercased()
    }
}
