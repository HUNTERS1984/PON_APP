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

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        IQKeyboardManager.sharedManager().enable = true
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
        LocationManager.sharedInstance
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.receivedTokenInvalidNotification(_:)), name:TokenInvalidNotification, object: nil)
    }
    
    func receivedTokenInvalidNotification(notification: NSNotification){
        HLKAlertView.show("Error", message: "Access token invalid", cancelButtonTitle: "OK", otherButtonTitles: nil, handler: nil)
        let vc = SplashViewController.instanceFromStoryBoard("Main")
        let nav = BaseNavigationController(rootViewController: vc)
        self.window?.rootViewController = nav
    }
    
    func setUpApplicationTheme() {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().barTintColor = UIColor(hex: 0x18c0d4)
        let navTitleTextAttributes = [
            NSFontAttributeName: UIFont.HiraginoSansW6(17),
            NSForegroundColorAttributeName:  UIColor.whiteColor()
        ]
        UINavigationBar.appearance().titleTextAttributes = navTitleTextAttributes
    }
    
    func setupStartViewController() {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.makeKeyAndVisible()
        
        let vc = SplashViewController.instanceFromStoryBoard("Main")
        let nav = BaseNavigationController(rootViewController: vc)
        self.window?.rootViewController = nav
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        FacebookLogin.application(app, openURL: url, options: options)
        LineLogin.sharedInstance.handleOpenURL(url)
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        FacebookLogin.application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        LineLogin.sharedInstance.handleOpenURL(url)
        return true
    }

    func applicationDidBecomeActive(application: UIApplication) {
        FacebookLogin.activateApp()
    }

}

