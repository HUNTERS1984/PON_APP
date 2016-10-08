//
//  LineLogin.swift
//  PonApp
//
//  Created by HaoLe on 9/21/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class LineLogin {
    
    fileprivate let adapter = LineAdapter.withConfigFile()
    
    class var sharedInstance: LineLogin {
        struct Static {
            static let instance = LineLogin()
        }
        return Static.instance
    }
    
    func startObserveLineAdapterNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.authorizationDidChange(_:)),
                                               name: NSNotification.Name.LineAdapterAuthorizationDidChange,
                                               object: nil)
    }
    
    @objc func authorizationDidChange(_ notification: Notification) {
        let adapter = notification.object as! LineAdapter
        if adapter.isAuthorized {
            alert("Login success!", message: "")
            return
        }
        
        if let error = (notification as NSNotification).userInfo?["error"] as? NSError {
            alert("Login error!", message: error.localizedDescription)
        }
        
    }
    
    func loginWithLine() {
        if (adapter?.isAuthorized)! {
            alert("Already authorized", message: "")
            return
        }
        
        if !(adapter?.canAuthorizeUsingLineApp)! {
            alert("LINE is not installed", message: "")
            return
        }
        adapter?.authorize()
    }
    
    func logout() {
        adapter?.unauthorize()
        alert("Logged out", message: "")
    }
    
    func alert(_ title: String, message: String) {
        UIAlertController.present(title: title, message: message, actionTitles: ["OK"])
    }
    
    func handleLaunchOptions(_ launchOptions: [AnyHashable: Any]?) {
        LineAdapter.handleLaunchOptions(launchOptions)
    }
    
    func handleOpenURL(_ url: URL) {
        LineAdapter.handleOpen(url)
    }
}
