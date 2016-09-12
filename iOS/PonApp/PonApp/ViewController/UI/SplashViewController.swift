//
//  SplashViewController.swift
//  PonApp
//
//  Created by OSXVN on 9/2/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class SplashViewController: BaseViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var sloganLabel: UILabel!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var mailButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        self.backgroundImageView.image = UIImage(named: "splash_background")
        self.facebookButton.setImage(UIImage(named: "splash_button_facebook"), forState: .Normal)
        self.twitterButton.setImage(UIImage(named: "splash_button_twitter"), forState: .Normal)
        self.mailButton.setImage(UIImage(named: "splash_button_email"), forState: .Normal)
    }
    
}

//MARK: - IBAction
extension SplashViewController {
    
    @IBAction func facebookButtonPressed(sender: AnyObject) {
        self.setupTabbarViewController()
    }
    
    @IBAction func twitterButtonPressed(sender: AnyObject) {
        let vc = SignUpViewController.instanceFromStoryBoard("Register")
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func mailButtonPressed(sender: AnyObject) {
        let vc = SignInViewController.instanceFromStoryBoard("Register")
        self.navigationController?.pushViewController(vc, animated: false)
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
