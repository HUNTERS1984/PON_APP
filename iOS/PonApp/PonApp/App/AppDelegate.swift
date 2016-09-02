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
        self.setupApplicationData()
//        self.setUpApplicationTheme()
        self.setupStartViewController()
        return true
    }
    
    func setupApplicationData() {
        //Google Map
        GMSServices.provideAPIKey(GoogleMapAPIKey)
        LocationManager.sharedInstance
    }
    
    func setUpApplicationTheme() {
        // Configure Application status bar
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        // Configure Navigation Bar
        UINavigationBar.appearance().tintColor = UIColor(hex: DefaultGreenColor)
        let navTitleTextAttributes = [
            NSFontAttributeName: UIFont.SourceSansProRegular(16),
            NSForegroundColorAttributeName:  UIColor(hex: DefaultTextColor)
        ]
        UINavigationBar.appearance().titleTextAttributes = navTitleTextAttributes
        
        
        let tabNormalTitleTextAttributes = [
            NSFontAttributeName: UIFont.SourceSansProRegular(12),
            NSForegroundColorAttributeName:  UIColor(hex: DefaultGreenColor)
        ]
        
        let tabSelectedTitleTextAttributes = [
            NSFontAttributeName: UIFont.SourceSansProRegular(12),
            NSForegroundColorAttributeName:  UIColor(hex: DefaultTextColor)
        ]
        
        UITabBarItem.appearance().setTitleTextAttributes(tabNormalTitleTextAttributes, forState: UIControlState.Normal)
        UITabBarItem.appearance().setTitleTextAttributes(tabSelectedTitleTextAttributes, forState: UIControlState.Selected)
        UITabBar.appearance().tintColor = UIColor(hex: DefaultGreenColor)
        UITabBar.appearance().barTintColor = UIColor(hex: DefaultGreenColor)
    }
    
    func setupStartViewController() {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.makeKeyAndVisible()
        
        let vc = SplashViewController.instanceFromStoryBoard()
        self.window?.rootViewController = vc
        
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
    }


}

