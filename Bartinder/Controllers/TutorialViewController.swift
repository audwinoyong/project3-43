//
//  TutorialViewController.swift
//  Bartinder
//
//  Created by Jason Kumar on 15.05.18.
//  Copyright © 2018 Bartinder. All rights reserved.
//

import Foundation
import SnapKit

class TutorialViewController: UIViewController
{
    // MARK: Properties
    
    var imgLeftArrow = UIImageView(image: UIImage(named: "Arrow_Left"))
    var imgRightArrow = UIImageView(image: UIImage(named: "Arrow_Right"))
    var lblTutorial = UILabel()
    var btnDismiss = UIButton()
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupView()
        
        animateArrowsInwards()
    }
    
    
    // MARK: View Lifecycle
    
    func setupView()
    {
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        // lblTutorial
        view.addSubview(lblTutorial)
        lblTutorial.snp.makeConstraints({ make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(64)
        })
        lblTutorial.textColor = .white
        lblTutorial.numberOfLines = 0
        lblTutorial.text = "Swipe left and right to navigate between drinks."
        
        
        // imgLeftArrow
        view.addSubview(imgLeftArrow)
        imgLeftArrow.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32)
            make.left.equalToSuperview().inset(8)
        }
        imgLeftArrow.tintColor = .white
        
        
        // imgRightArrow
        view.addSubview(imgRightArrow)
        imgRightArrow.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32)
            make.right.equalToSuperview().inset(8)
        }
        imgRightArrow.tintColor = .white
        
        
        // btnDismiss
        view.addSubview(btnDismiss)
        btnDismiss.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview().inset(32)
        }
        btnDismiss.setTitleColor(.white, for: .normal)
        btnDismiss.setTitle("OK", for: .normal)
        btnDismiss.addTarget(self, action: #selector(onBtnDismissTapped), for: .touchUpInside)
    }
    
    
    // MARK: User Interaction
    
    @objc func onBtnDismissTapped()
    {
        UserDefaultsHelper.setHasSeenTutorial(true)
        
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: Additional Helpers
    
    func animateArrowsInwards()
    {
        imgLeftArrow.snp.updateConstraints { update in
            update.left.equalToSuperview().inset(24)
        }
        imgRightArrow.snp.updateConstraints { update in
            update.right.equalToSuperview().inset(24)
        }
        view.setNeedsUpdateConstraints()
        
        UIView.animate(withDuration: 1.0, animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.animateArrowsOutwards()
        })
    }
    
    func animateArrowsOutwards()
    {
        imgLeftArrow.snp.updateConstraints { update in
            update.left.equalToSuperview().inset(8)
        }
        imgRightArrow.snp.updateConstraints { update in
            update.right.equalToSuperview().inset(8)
        }
        view.setNeedsUpdateConstraints()
        
        UIView.animate(withDuration: 1.0, animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.animateArrowsInwards()
        })
    }
}
