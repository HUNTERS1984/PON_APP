//
//  SplashViewController.swift
//  PonApp
//
//  Created by OSXVN on 9/2/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class SplashViewController: BaseViewController {
    
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

//MARK: - IBAction
extension SplashViewController {
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        self.setupTabbarViewController()
    }
    
}

//MARK: - Private methods
extension SplashViewController {
    private func setupTabbarViewController() {
        let mainNavigationController: BaseNavigationController?
        let accountNavigationController: BaseNavigationController?
        let favoriteNavigationController: BaseNavigationController?
        
        var mainTabbarViewController: BaseTabBarController?
        
        let mainViewController = MainViewController.instanceFromStoryBoard("Main")
        mainNavigationController = BaseNavigationController(rootViewController: mainViewController)
        
        let accountViewController = AccountViewController.instanceFromStoryBoard("Main")
        accountNavigationController = BaseNavigationController(rootViewController: accountViewController)
        
        let favoriteViewController = FavoriteViewController.instanceFromStoryBoard("Main")
        favoriteNavigationController = BaseNavigationController(rootViewController: favoriteViewController)

        
        mainTabbarViewController = BaseTabBarController()
        mainTabbarViewController?.viewControllers = [
            favoriteNavigationController!,
            mainNavigationController!,
            accountNavigationController!
        ]
        mainTabbarViewController?.selectedIndex = 1
        mainTabbarViewController?.tabBar.hidden = true
        self.appDelegate?.window?.rootViewController = mainTabbarViewController!
    }
}
