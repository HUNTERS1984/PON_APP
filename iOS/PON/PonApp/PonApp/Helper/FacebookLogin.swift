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

public typealias FacebookLoginHandler = (_ result: [String: String]?, _ error: Error?) -> Void

class FacebookLogin {
    
    class func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable: Any]?) {
        FBSDKProfile.enableUpdates(onAccessTokenChange: true)
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    class func activateApp() {
        FBSDKAppEvents.activateApp()
    }
    
    class func logInWithReadPermissions(_ permissions: [String]?, fromViewController: UIViewController, handler: @escaping (FacebookLoginHandler)) {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        loginManager.logIn(withReadPermissions: permissions, from: fromViewController) {(result: FBSDKLoginManagerLoginResult?, error: Error?) in
            if let _ = error {
                handler(nil, error)
            }else {
                if result!.isCancelled {
                    handler(nil, NSError(domain: "PON", code: 1, userInfo: ["error":"User cancelled login"]))
                }else {
                    if let _ = FBSDKAccessToken.current().tokenString {
                        let request = FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields": "name, email"])
                        _ = request?.start(completionHandler: { (connection, result, error) in
                            if let _ = error {
                                handler(nil, NSError(domain: "PON", code: 1, userInfo: ["error":"Can not get user infomation"]))
                            }else {
                                var data: [String: String] = [
                                    "token": FBSDKAccessToken.current().tokenString
                                ]
                                if let result = result as? [String: String] {
                                    data["id"] = result["id"]
                                    data["name"] = result["name"]
                                    data["email"] = result["email"]
                                }
                                handler(data, nil)
                            }
                        })
                    }else {
                        handler(nil, NSError(domain: "PON", code: 1, userInfo: ["error":"Cancel login facebook"]))
                    }
                }
            }
        }
    }
    
    class func application(_ app: UIApplication, openURL url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) {
        FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    
    class func application(_ application: UIApplication, openURL url: URL, sourceApplication: String?, annotation: AnyObject) {
        FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }

}
