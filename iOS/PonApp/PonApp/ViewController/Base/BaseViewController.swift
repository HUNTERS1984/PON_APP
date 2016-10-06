//
//  BaseViewController.swift
//  PonApp
//
//  Created by OSXVN on 9/2/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit
import MBProgressHUD

class BaseViewController: UIViewController {
    
    deinit {
        loggingPrint("\(self.classForCoder) deinit")
    }
    
    //MARK: - Public
    weak var appDelegate:AppDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.view.backgroundColor = UIColor(hex: DefaultBackgroundColor)
        
        setUpComponentsOnLoad()
        setUpUserInterface()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle{
        return UIStatusBarStyle.default;
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configUserInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpComponentsOnWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpComponentsOnDidAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        setUpComponentsOnDidDisappear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setUpComponentsOnWillDisappear()
    }
    
}

//MARK: - Loading
extension BaseViewController {
    
    func showHUD() {
        DispatchQueue.main.async(execute: {
            self.view.endEditing(true)
            MBProgressHUD.showAdded(to: self.view, animated: true)
            return
        })
    }
    
    func hideHUD() {
        DispatchQueue.main.async(execute: {
            MBProgressHUD.hide(for: self.view, animated: true)
            return
        })
    }
    
}

//MARK: - Public Methods
extension BaseViewController {
    
    func presentAlert(with title: String = "Error", message: String) {
        UIAlertController.present(title: title, message: message, actionTitles: ["OK"]) { (action) -> () in
            print(action.title)
        }
    }
    
    func hideBackButton() {
        let button = UIBarButtonItem(image: UIImage(), style: .plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = button
    }
    
    func showBackButton() {
        let button = UIBarButtonItem(image: UIImage(named: "nav_back"), style: .plain, target: self, action: #selector(self.backButtonPressed(_: )))
        self.navigationItem.leftBarButtonItem = button
    }
    
    func showRightBarButtonWithTitle(_ title: String) {
        let button = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(self.rightBarButtonPressed(_: )))
        button.setTitleTextAttributes([NSFontAttributeName: UIFont.HiraginoSansW6(17)], for: UIControlState())
        self.navigationItem.rightBarButtonItem = button
    }
    
    func showCloseButton() {
        let button = UIBarButtonItem(image: UIImage(named: "nav_close_white"), style: .plain, target: self, action: #selector(self.navCloseButtonPressed(_: )))
        self.navigationItem.leftBarButtonItem = button
    }
    
    func setupTabbarViewController() {
        let mainNavigationController: BaseNavigationController?
        let accountNavigationController: BaseNavigationController?
        let favoriteNavigationController: BaseNavigationController?
        
        var mainTabbarViewController: BaseTabBarController?
        
        let mainViewController = MainViewController.instanceFromStoryBoard("Main")
        mainNavigationController = BaseNavigationController(rootViewController: mainViewController!)
        
        let accountViewController = AccountViewController.instanceFromStoryBoard("Main")
        accountNavigationController = BaseNavigationController(rootViewController: accountViewController!)
        
        let favoriteViewController = FavoriteViewController.instanceFromStoryBoard("Main")
        favoriteNavigationController = BaseNavigationController(rootViewController: favoriteViewController!)
        
        
        mainTabbarViewController = BaseTabBarController()
        mainTabbarViewController?.viewControllers = [
            favoriteNavigationController!,
            mainNavigationController!,
            accountNavigationController!
        ]
        mainTabbarViewController?.selectedIndex = 1
        mainTabbarViewController?.tabBar.isHidden = true
        self.appDelegate?.window?.rootViewController = mainTabbarViewController!
    }
}

//MARK: - IBAction 
extension BaseViewController {
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func rightBarButtonPressed(_ sender: AnyObject) {
        
    }
    
    @IBAction func navCloseButtonPressed(_ sender: AnyObject) {
        self.navigationController!.popViewController(animated: true)
    }
    
}
