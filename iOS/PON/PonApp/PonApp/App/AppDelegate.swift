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
    var remoteNotificationData: [String: Any]?
    var isRemoteNotification = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        OneSignalPushNotification.initPush(with: application, launchOptions: launchOptions, appId: OneSignalAppID)
        IQKeyboardManager.shared().isEnabled = true
        FacebookLogin.application(application, didFinishLaunchingWithOptions: launchOptions)
        TwitterLogin.setupTwitterLogin()
        LineLogin.shared.handleLaunchOptions(launchOptions)
        self.setupApplicationData()
        self.setUpApplicationTheme()
        self.setupApplication(with: launchOptions)
        return true
    }
    
    func setupApplication(with launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        //Handle notification
        if let _ = launchOptions {
            if let _ = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as! [String : Any]? {
                self.isRemoteNotification = true
            }else {
                self.isRemoteNotification = false
            }
        }else {
            self.isRemoteNotification = false
        }
        self.setupStartViewController()
    }
    
    func setupApplicationData() {
        GMSServices.provideAPIKey(GoogleMapAPIKey)
        LocationManager.sharedInstance.initLocationManager()
        ReachabilityManager.sharedInstance.initReachabilityManager()
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.receivedTokenInvalidNotification(_:)), name:NSNotification.Name(rawValue: TokenInvalidNotification), object: nil)
    }
    
    func receivedTokenInvalidNotification(_ notification: Notification){
        UIAlertController.present(title: "Error", message: AccessTokenExpiry, actionTitles: [OK]) { (action) -> () in
            loggingPrint(action.title)
        }
        
        let vc = SplashViewController.instanceFromStoryBoard("Main")
        let nav = BaseNavigationController(rootViewController: vc!)
        self.window?.rootViewController = nav
    }
    
    func setUpApplicationTheme() {
        UIApplication.shared.statusBarStyle = .lightContent
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor = UIColor(hex: DefaultBlueTextColor)
        let navTitleTextAttributes = [
            NSFontAttributeName: UIFont.HiraginoSansW6(16),
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
        LineLogin.shared.handleOpenURL(url)
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        FacebookLogin.application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation as AnyObject)
        LineLogin.shared.handleOpenURL(url)
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        FacebookLogin.activateApp()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var token = ""
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
    }
    
}

