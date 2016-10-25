//
//  SignInViewController.swift
//  PonStaffApp
//
//  Created by HaoLe on 10/25/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class SignInViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
    }
    
}

extension SignInViewController {
    
    func setupTabbarViewController() {
        let couponNavigationController: BaseNavigationController?
        let pointNavigationController: BaseNavigationController?
        
        var mainTabbarViewController: BaseTabBarController?
        
        let requestCouponVC = RequestCouponViewController.instanceFromStoryBoard("Main")
        couponNavigationController = BaseNavigationController(rootViewController: requestCouponVC!)
        
        let pointVC = PointViewController.instanceFromStoryBoard("Main")
        pointNavigationController = BaseNavigationController(rootViewController: pointVC!)
        
        
        mainTabbarViewController = BaseTabBarController()
        mainTabbarViewController?.viewControllers = [
            couponNavigationController!,
            pointNavigationController!
        ]
        mainTabbarViewController?.selectedIndex = 0
        mainTabbarViewController?.tabBar.isHidden = true
        self.appDelegate?.window?.rootViewController = mainTabbarViewController!
    }
    
    @IBAction func signInButtonPressed(_ sender: AnyObject) {
        setupTabbarViewController()
    }
    
}
