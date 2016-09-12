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
        self.setUpApplicationTheme()
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

