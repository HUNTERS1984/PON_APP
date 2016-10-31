//
//  AppDelegate.swift
//  PonStaffApp
//
//  Created by HaoLe on 10/24/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupApplicationData()
        setUpApplicationTheme()
        setupStartViewController()
        return true
    }
    
    func setUpApplicationTheme() {
        UIApplication.shared.statusBarStyle = .lightContent
        UINavigationBar.appearance().tintColor = UIColor(hex: DefaultGreenTextColor)
        UINavigationBar.appearance().barTintColor = UIColor.white
        let navTitleTextAttributes = [
            //NSFontAttributeName: UIFont.HiraginoSansW6(16),
            NSForegroundColorAttributeName:  UIColor(hex: DefaultBlackTextColor)
        ]
        UINavigationBar.appearance().titleTextAttributes = navTitleTextAttributes
    }
    
    func setupStartViewController() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        
        let vc = SignInViewController.instanceFromStoryBoard("Main")
        self.window?.rootViewController = vc
    }
    
    func setupApplicationData() {
        ReachabilityManager.sharedInstance.initReachabilityManager()
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.receivedTokenInvalidNotification(_:)), name:NSNotification.Name(rawValue: TokenInvalidNotification), object: nil)
    }
    
    func receivedTokenInvalidNotification(_ notification: Notification){
        UIAlertController.present(title: "Error", message: "Access token invalid", actionTitles: ["OK"]) { (action) -> () in
            loggingPrint(action.title)
        }
        
        let vc = SignInViewController.instanceFromStoryBoard("Main")
        self.window?.rootViewController = vc
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }


}

