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

typealias TwitterLoginCallback = (_ success: Bool, _ result: Any?) -> Void

class TwitterLogin {
    
    var callback: TwitterLoginCallback? = nil
    var apiClient: TWTRAPIClient!
    
    class var sharedInstance: TwitterLogin {
        struct Static {
            static let instance = TwitterLogin()
        }
        return Static.instance
    }
    
    fileprivate func initWithConsumerKey(_ consumerKey: String, consumerSecret: String) {
        if (consumerKey.characters.count == 0 || consumerSecret.characters.count == 0) {
            NSLog("\n\nMissing your application credentials ConsumerKey and ConsumerSecret. You cannot run the app until you provide this in the code.\n\n");
            return;
        }
        Twitter.sharedInstance().start(withConsumerKey: consumerKey, consumerSecret: consumerSecret)
    }
    
    fileprivate func setupTwitterLogin() {
        Fabric.with([Twitter.self])
    }
    
    fileprivate func isSessionValid() -> Bool {
        let userID = Twitter.sharedInstance().sessionStore.session()?.userID
        self.apiClient = TWTRAPIClient(userID: userID)
        if let _ = Twitter.sharedInstance().sessionStore.session() {
            return true
        }else {
            return false
        }
    }
    
    fileprivate func loginViewControler(_ aViewController: UIViewController, aCallback: @escaping TwitterLoginCallback) {
        self.callback = aCallback
        let userID = Twitter.sharedInstance().sessionStore.session()?.userID
        if let _ = userID {
            Twitter.sharedInstance().sessionStore.logOutUserID(userID!)
        }
        Twitter.sharedInstance().logIn(with: aViewController, methods: .webBased) { (session, error) in
            if let _ = error {
                self.callback?(false, error)
            }else {
                let userID = Twitter.sharedInstance().sessionStore.session()?.userID
                self.apiClient = TWTRAPIClient(userID: userID)
                self.callback?(true, session)
            }
        }
    }
    
    func share(_ aViewController: UIViewController, aCallback: @escaping TwitterLoginCallback) {
        self.callback = aCallback
        Twitter.sharedInstance().logIn(with: aViewController, methods: .webBased) { (session, error) in
            if let _ = error {
                self.callback?(false, error)
            }else {
                let session = Twitter.sharedInstance().sessionStore.session()
                print(Twitter.sharedInstance().sessionStore.session()!.userID)
                
                let composer = TWTRComposer()
                composer.setText("HAO")
                composer.setURL(URL(string: "pon.cm"))
                composer.show(from: aViewController, completion: { result in
                    if result == TWTRComposerResult.cancelled {
                        print("Tweet composition cancelled")
                    }else {
                        print("Sending Tweet!")
                    }
                    
                })
                self.callback?(true, session)
            }
        }
    }
    
    fileprivate func logoutCallback(_ aCallback: TwitterLoginCallback) {
        let userID = Twitter.sharedInstance().sessionStore.session()?.userID
        Twitter.sharedInstance().sessionStore.logOutUserID(userID!)
        aCallback(true, "Logged out")
    }
    
    class func initWithConsumerKey(_ consumerKey: String, consumerSecret: String) {
        TwitterLogin.sharedInstance.initWithConsumerKey(consumerKey, consumerSecret: consumerSecret)
    }
    
    class func setupTwitterLogin() {
        TwitterLogin.sharedInstance.setupTwitterLogin()
    }
    
    class func isSessionValid() -> Bool {
        return TwitterLogin.sharedInstance.isSessionValid()
    }
    
    class func loginViewControler(_ aViewController: UIViewController, aCallback: @escaping TwitterLoginCallback) {
        TwitterLogin.sharedInstance.loginViewControler(aViewController, aCallback: aCallback)
    }
    
    class func logoutCallback(_ aCallback: TwitterLoginCallback) {
        TwitterLogin.sharedInstance.logoutCallback(aCallback)
    }
}
