//
//  BaseNavigationController.swift
//  PonApp
//
//  Created by OSXVN on 9/2/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    deinit {
        loggingPrint("\(self.classForCoder) deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

//MARK: - Public Method
extension BaseNavigationController {
    
    func popToFirstViewControllerOfClass(_ aClass: AnyClass, animated: Bool) {
        var toViewController:UIViewController?
        for index in 0..<self.viewControllers.count {
            let viewController = self.viewControllers[index]
            if viewController.isKind(of: aClass) {
                toViewController = viewController
                break
            }
        }
        if toViewController == nil {
            return;
        }
        self.popToViewController(toViewController!, animated: animated)
    }
    
    func popToLastViewControllerOfClass(_ aClass: AnyClass, animated: Bool) {
        var toViewController:UIViewController?
        for index in (0..<self.viewControllers.count).reversed() {
            let viewController = self.viewControllers[index]
            if viewController.isKind(of: aClass) {
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
