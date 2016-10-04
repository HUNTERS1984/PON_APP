//
//  UIViewControllerExtension.swift
//  SpaOwnerIOS
//
//  Created by HaoLe on 7/4/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    /*
     *** Class Methods ***
     */
    class func instanceFromNib(_ nibName: String! = nil, bundle: Bundle! = nil) -> UIViewController! {
        var _nibName: String! = nil
        
        // If nibName == nil, get default name is Classname
        if (nibName == nil) {
            let fullClassName = NSStringFromClass(self)
            if let className = fullClassName.components(separatedBy: ".").last {
                _nibName = className
            }
        }
        else {
            _nibName = nibName
        }
        
        // Load from nib
        return self.init(nibName: _nibName, bundle: bundle)
    }
    
    class func instanceFromStoryBoard(_ storyboardName: String) -> UIViewController! {
        let fullClassName = NSStringFromClass(self)
        let storyboardId = fullClassName.components(separatedBy: ".").last
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: storyboardId!)
        return vc
    }
    /*
     *** Instance Methods ***
     */
    func defaultNavigationController() -> UINavigationController {
        // Return current NavigationController
        // If not, create new instance of NavigationController
        if let nav = self.navigationController {
            return nav
        }
        else {
            return UINavigationController(rootViewController: self)
        }
    }
    
    func setUpComponentsOnLoad() {}
    func setUpComponentsOnWillAppear() {}
    func setUpComponentsOnDidAppear() {}
    func setUpComponentsOnWillDisappear() {}
    func setUpComponentsOnDidDisappear() {}
    func setUpNavigationBar(){}
    func setUpUserInterface(){}
    func configUserInterface(){}
    
}
