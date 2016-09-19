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
    
    class func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) {
        FBSDKProfile.enableUpdatesOnAccessTokenChange(true)
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    class func activateApp() {
        FBSDKAppEvents.activateApp()
    }
    
    class func logInWithReadPermissions(permissions: [AnyObject], fromViewController: UIViewController, handler: FBSDKLoginManagerRequestTokenHandler) {
        let login = FBSDKLoginManager()
        login.logInWithReadPermissions(permissions, fromViewController: fromViewController, handler: handler)
    }
    
    class func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) {
        if #available(iOS 9.0, *) {
            FBSDKApplicationDelegate.sharedInstance().application(app, openURL: url, sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as! String, annotation: options[UIApplicationOpenURLOptionsAnnotationKey])
        } else {
            // Fallback on earlier versions
        }
    }
    
    class func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) {
        FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }

}
