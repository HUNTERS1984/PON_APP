//
//  TwitterLogin.swift
//  PonApp
//
//  Created by HaoLe on 9/20/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit
import TwitterKit
import Fabric

typealias TwitterLoginCallback = (success: Bool, result: Any?) -> Void

class TwitterLogin {
    
    var callback: TwitterLoginCallback? = nil
    var apiClient: TWTRAPIClient!
    
    class var sharedInstance: TwitterLogin {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: TwitterLogin? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = TwitterLogin()
        }
        return Static.instance!
    }
    
    private func initWithConsumerKey(consumerKey: String, consumerSecret: String) {
        if (consumerKey.characters.count == 0 || consumerSecret.characters.count == 0) {
            NSLog("\n\nMissing your application credentials ConsumerKey and ConsumerSecret. You cannot run the app until you provide this in the code.\n\n");
            return;
        }
        Twitter.sharedInstance().startWithConsumerKey(consumerKey, consumerSecret: consumerSecret)
    }
    
    private func setupTwitterLogin() {
        Fabric.with([Twitter.self])
    }
    
    private func isSessionValid() -> Bool {
        let userID = Twitter.sharedInstance().sessionStore.session()?.userID
        self.apiClient = TWTRAPIClient(userID: userID)
        if let _ = Twitter.sharedInstance().sessionStore.session() {
            return true
        }else {
            return false
        }
    }
    
    private func loginViewControler(aViewController: UIViewController, aCallback: TwitterLoginCallback) {
        self.callback = aCallback
        let userID = Twitter.sharedInstance().sessionStore.session()?.userID
        if let _ = userID {
            Twitter.sharedInstance().sessionStore.logOutUserID(userID!)
        }
        Twitter.sharedInstance().logInWithViewController(aViewController, methods: .WebBased, completion: { (session: TWTRSession?, error: NSError?) in
            if let _ = error {
                self.callback?(success: false, result: error)
            }else {
                let userID = Twitter.sharedInstance().sessionStore.session()?.userID
                self.apiClient = TWTRAPIClient(userID: userID)
                self.callback?(success: true, result: session)
            }
        })
    }
    
    private func logoutCallback(aCallback: TwitterLoginCallback) {
        let userID = Twitter.sharedInstance().sessionStore.session()?.userID
        Twitter.sharedInstance().sessionStore.logOutUserID(userID!)
        aCallback(success: true, result: "Logged out")
    }
    
    class func initWithConsumerKey(consumerKey: String, consumerSecret: String) {
        TwitterLogin.sharedInstance.initWithConsumerKey(consumerKey, consumerSecret: consumerSecret)
    }
    
    class func setupTwitterLogin() {
        TwitterLogin.sharedInstance.setupTwitterLogin()
    }
    
    class func isSessionValid() -> Bool {
        return TwitterLogin.sharedInstance.isSessionValid()
    }
    
    class func loginViewControler(aViewController: UIViewController, aCallback: TwitterLoginCallback) {
        TwitterLogin.sharedInstance.loginViewControler(aViewController, aCallback: aCallback)
    }
    
    class func logoutCallback(aCallback: TwitterLoginCallback) {
        TwitterLogin.sharedInstance.logoutCallback(aCallback)
    }
}
