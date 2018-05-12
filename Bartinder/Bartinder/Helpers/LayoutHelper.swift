//
//  LayoutHelper.swift
//  Bartinder
//
//  Created by Jason Kumar on 12.05.18.
//  Copyright © 2018 Bartinder. All rights reserved.
//

import Foundation
import UIKit

struct LayoutHelper
{
    // iPhone X has higher statusBar
    // When in landscape orientation, width and height are swapped
    static var statusBarHeight: CGFloat
    {
        let statusBarSize = UIApplication.shared.statusBarFrame.size
        return Swift.min(statusBarSize.width, statusBarSize.height)
    }
}
