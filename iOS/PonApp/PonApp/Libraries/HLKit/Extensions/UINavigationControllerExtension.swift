//
//  UINavigationControllerExtension.swift
//  PonApp
//
//  Created by HaoLe on 9/6/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    
    public func presentTransparentNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navigationBar.shadowImage = UIImage()
        navigationBar.translucent = true
    }
    
    public func hideTransparentNavigationBar() {
        navigationBar.setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)
        navigationBar.shadowImage = nil
        navigationBar.tintColor = nil
        navigationBar.translucent = false
    }
}
