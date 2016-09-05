//
//  BaseNavigationController.swift
//  PonApp
//
//  Created by OSXVN on 9/2/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

//MARK: - Public Method
extension BaseNavigationController {
    
    func popToFirstViewControllerOfClass(aClass: AnyClass, animated: Bool) {
        var toViewController:UIViewController?
        for index in 0..<self.viewControllers.count {
            let viewController = self.viewControllers[index]
            if viewController.isKindOfClass(aClass) {
                toViewController = viewController
                break
            }
        }
        if toViewController == nil {
            return;
        }
        self.popToViewController(toViewController!, animated: animated)
    }
    
    func popToLastViewControllerOfClass(aClass: AnyClass, animated: Bool) {
        var toViewController:UIViewController?
        for index in (0..<self.viewControllers.count).reverse() {
            let viewController = self.viewControllers[index]
            if viewController.isKindOfClass(aClass) {
                toViewController = viewController
                break
            }
        }
        
        if toViewController == nil {
            return
        }
        self.popToViewController(toViewController!, animated: animated)
    }
    
}