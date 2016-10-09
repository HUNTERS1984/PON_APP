//
//  AppDelegate.swift
//  PonApp
//
//  Created by HaoLe on 9/1/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        OneSignalPushNotification.initPush(with: launchOptions, appId: OneSignalAppID)
        IQKeyboardManager.shared().isEnabled = true
        FacebookLogin.application(application, didFinishLaunchingWithOptions: launchOptions)
        TwitterLogin.setupTwitterLogin()
        LineLogin.sharedInstance.handleLaunchOptions(launchOptions)
        self.setupApplicationData()
        self.setUpApplicationTheme()
        self.setupStartViewController()
        return true
    }
    
    func setupApplicationData() {
        GMSServices.provideAPIKey(GoogleMapAPIKey)
        LocationManager.sharedInstance.initLocationManager()
        ReachabilityManager.sharedInstance.initReachabilityManager()
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.receivedTokenInvalidNotification(_:)), name:NSNotification.Name(rawValue: TokenInvalidNotification), object: nil)
    }
    
    func receivedTokenInvalidNotification(_ notification: Notification){
        UIAlertController.present(title: "Error", message: "Access token invalid", actionTitles: ["OK"]) { (action) -> () in
            print(action.title)
        }
        
        let vc = SplashViewController.instanceFromStoryBoard("Main")
        let nav = BaseNavigationController(rootViewController: vc!)
        self.window?.rootViewController = nav
    }
    
    func setUpApplicationTheme() {
        UIApplication.shared.statusBarStyle = .lightContent
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor = UIColor(hex: 0x18c0d4)
        let navTitleTextAttributes = [
            NSFontAttributeName: UIFont.HiraginoSansW6(17),
            NSForegroundColorAttributeName:  UIColor.white
        ]
        UINavigationBar.appearance().titleTextAttributes = navTitleTextAttributes
    }
    
    func setupStartViewController() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        
        let vc = SplashViewController.instanceFromStoryBoard("Main")
        let nav = BaseNavigationController(rootViewController: vc!)
        self.window?.rootViewController = nav
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        FacebookLogin.application(app, openURL: url, options: options)
        LineLogin.sharedInstance.handleOpenURL(url)
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        FacebookLogin.application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation as AnyObject)
        LineLogin.sharedInstance.handleOpenURL(url)
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        FacebookLogin.activateApp()
    }

}

