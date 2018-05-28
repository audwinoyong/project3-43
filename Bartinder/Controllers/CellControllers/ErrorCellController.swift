//
//  EmptyCellController.swift
//  Bartinder
//
//  Created by Jason Kumar on 13.05.18.
//  Copyright © 2018 Bartinder. All rights reserved.
//

import Foundation
import SnapKit

class ErrorCellController: UITableViewCell
{
    // MARK: Properties
    
    var imgPullToRefresh = UIImageView(image: UIImage(named: "Arrow_Down"))
    var lblPullToRefresh = UILabel()
    var lblError = UILabel()
    
    var isAnimating = false
    
    
    // MARK: Lifecycle
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
        
        isAnimating = false
    }
    
    
    // MARK: View Lifecycle
    
    func setupView()
    {
        isUserInteractionEnabled = false
        
        // imgPullToRefresh
        contentView.addSubview(imgPullToRefresh)
        imgPullToRefresh.snp.makeConstraints({ make in
            make.width.height.equalTo(32)
            make.top.equalToSuperview().inset(8)
            make.centerX.equalToSuperview()
        })
        imgPullToRefresh.tintColor = .darkGray
        
        
        // lblPullToRefresh
        contentView.addSubview(lblPullToRefresh)
        lblPullToRefresh.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(64)
            make.centerX.equalToSuperview()
        }
        lblPullToRefresh.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize, weight: .light)
        lblPullToRefresh.textColor = .lightGray
        lblPullToRefresh.text = "Pull down to retry"
        
        
        // lblError
        contentView.addSubview(lblError)
        lblError.snp.makeConstraints({ make in
            make.center.equalToSuperview()
        })
        lblError.textColor = .darkGray
        lblError.text = "Could not connect to the internet!"
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        guard !isAnimating else
        {
            return
        }
        
        isAnimating = true
        
        // Start animation
        animateArrowDown()
    }
    
    
    // MARK: User Interaction
    
    
    // MARK: Additional Helpers
    
    func animateArrowDown()
    {
        guard isAnimating else
        {
            return
        }
        
        imgPullToRefresh.snp.updateConstraints { update in
        update.top.equalToSuperview().inset(24)
        }
        setNeedsUpdateConstraints()
        
        UIView.animate(withDuration: 1.0, animations: {
            self.layoutIfNeeded()
        }, completion: { _ in
            self.animateArrowUp()
        })
    }
    
    func animateArrowUp()
    {
        guard isAnimating else
        {
            return
        }
        
        imgPullToRefresh.snp.updateConstraints { update in
            update.top.equalToSuperview().inset(8)
        }
        setNeedsUpdateConstraints()
        
        UIView.animate(withDuration: 1.0, animations: {
            self.layoutIfNeeded()
        }, completion: { _ in
            self.animateArrowDown()
        })
    }
}
