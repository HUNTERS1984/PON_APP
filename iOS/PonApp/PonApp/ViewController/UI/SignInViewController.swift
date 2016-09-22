//
//  SignInViewController.swift
//  PonApp
//
//  Created by HaoLe on 9/12/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class SignInViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        self.title = "ログイン"
        self.showCloseButton()
    }

}

//MARK: - IBAction
extension SignInViewController {
    
    @IBAction func signInButtonPressed(sender: AnyObject) {
        self.setupTabbarViewController()
    }
    
}

extension SignInViewController {
    
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
