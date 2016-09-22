//
//  LineLogin.swift
//  PonApp
//
//  Created by HaoLe on 9/21/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class LineLogin {
    
    private let adapter = LineAdapter.adapterWithConfigFile()
    
    class var sharedInstance: LineLogin {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: LineLogin? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = LineLogin()
        }
        return Static.instance!
    }
    
    func startObserveLineAdapterNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(self.authorizationDidChange(_:)),
                                                         name: LineAdapterAuthorizationDidChangeNotification,
                                                         object: nil)
    }
    @objc func authorizationDidChange(notification: NSNotification) {
        let adapter = notification.object as! LineAdapter
        
        if adapter.authorized {
            alert("Login success!", message: "")
            return
        }
        
        if let error = notification.userInfo?["error"] as? NSError {
            alert("Login error!", message: error.localizedDescription)
        }
        
    }
    
    func loginWithLine() {
        if adapter.authorized {
            alert("Already authorized", message: "")
            return
        }
        
        if !adapter.canAuthorizeUsingLineApp {
            alert("LINE is not installed", message: "")
            return
        }
        adapter.authorize()
    }
    
    func logout() {
        adapter.unauthorize()
        alert("Logged out", message: "")
    }
    
    func alert(title: String, message: String) {
        let alert = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
    
    func handleLaunchOptions(launchOptions: [NSObject: AnyObject]?) {
        self.startObserveLineAdapterNotification()
        LineAdapter.handleLaunchOptions(launchOptions)
    }
    
    func handleOpenURL(url: NSURL) {
        LineAdapter.handleOpenURL(url)
    }
}
