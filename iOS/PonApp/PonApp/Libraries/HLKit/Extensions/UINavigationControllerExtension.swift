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
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
    }
    
    public func hideTransparentNavigationBar() {
        navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        navigationBar.shadowImage = nil
        navigationBar.tintColor = nil
        navigationBar.isTranslucent = false
    }
}
