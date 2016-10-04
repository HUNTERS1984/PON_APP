//
//  FacebookLogin.swift
//  PonApp
//
//  Created by HaoLe on 9/19/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class FacebookLogin {
    
    class func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable: Any]?) {
        FBSDKProfile.enableUpdates(onAccessTokenChange: true)
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    class func activateApp() {
        FBSDKAppEvents.activateApp()
    }
    
    class func logInWithReadPermissions(_ permissions: [AnyObject], fromViewController: UIViewController, handler: @escaping FBSDKLoginManagerRequestTokenHandler) {
        let login = FBSDKLoginManager()
        login.logIn(withReadPermissions: permissions, from: fromViewController, handler: handler)
    }
    
    class func application(_ app: UIApplication, openURL url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) {
        if #available(iOS 9.0, *) {
            FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        } else {
            // Fallback on earlier versions
        }
    }
    
    class func application(_ application: UIApplication, openURL url: URL, sourceApplication: String?, annotation: AnyObject) {
        FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }

}
