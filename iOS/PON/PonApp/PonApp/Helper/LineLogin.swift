//
//  LineLogin.swift
//  PonApp
//
//  Created by HaoLe on 9/21/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class LineLogin {
    
    private let adapter = LineAdapter.default()!
    private var lineAdapterWebViewController: LineAdapterWebViewController?
    
    class var shared: LineLogin {
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
            self.getMyProfile()
            if let _ = lineAdapterWebViewController {
                lineAdapterWebViewController!.dismiss(animated: true, completion: nil)
            }
            alert("Login success!", message: "")
            return
        }
        if let error = notification.userInfo?["error"] as? NSError {
            if let _ = lineAdapterWebViewController {
                lineAdapterWebViewController!.dismiss(animated: true, completion: nil)
            }
            alert("Login error!", message: error.localizedDescription)
        }
        
    }
    
    func loginWithLine() {
        if (adapter.isAuthorized) {
            alert("Already authorized", message: "")
            return
        }
        
        if !(adapter.canAuthorizeUsingLineApp) {
            alert("LINE is not installed", message: "")
            return
        }
        adapter.authorize()
    }
    
    func loginInApp(_ aViewController: UIViewController) {
        if adapter.isAuthorized {
            alert("Already authorized", message: "")
            getMyProfile()
            tryPostEventApi()
            //uploadProfileImage()
            return
        }
        
        lineAdapterWebViewController = LineAdapterWebViewController(adapter: adapter, with: LineAdapterWebViewOrientation.all)
        lineAdapterWebViewController?.navigationItem.leftBarButtonItem = LineAdapterNavigationController.barButtonItem(withTitle: "Cancel", target: self, action: #selector(self.cancel(_:)))
        let navigationController = LineAdapterNavigationController(rootViewController: lineAdapterWebViewController!)
        aViewController.present(navigationController, animated: true, completion: nil)
    }
    
    @objc
    func cancel(_ sender: AnyObject) {
        lineAdapterWebViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    func logout() {
        adapter.unauthorize()
        alert("Logged out", message: "")
    }
    
    func alert(_ title: String, message: String) {
        UIAlertController.present(title: title, message: message, actionTitles: ["OK"])
    }
    
    func handleLaunchOptions(_ launchOptions: [AnyHashable: Any]?) {
        LineAdapter.handleLaunchOptions(launchOptions)
        self.startObserveLineAdapterNotification()
    }
    
    func handleOpenURL(_ url: URL) {
        LineAdapter.handleOpen(url)
    }
    
    //MARK: - API
    func getMyProfile() {
        if !adapter.isAuthorized {
            alert("Login first!", message: "")
            return
        }
        
        adapter.getLineApiClient().getMyProfile {[unowned self] (profile, error) -> Void in
            if let error = error {
                self.alert("Error occured!", message: error.localizedDescription)
                return
            }
            print(profile as Any)
            //let displayName = profile?["displayName"] as! String
            //self.alert("Your name is \(displayName)", message: "")
        }
    }
    
    func tryPostEventApi() {
        if !adapter.isAuthorized {
            alert("Login first!", message: "")
            return
        }
        let content = [
            "apiVer" : 2,
            "cmd": "create",
            "device" : "iphone:5.1",
            "region" : "JP",
            "postText" : "I Love this App!",
            "feedNo" : 1,
            "test" : true,
            ] as [String : Any]
        
        adapter.getLineApiClient().postEvent(to: ["u882c0d08d8e6862f1281afab27a758f9"], toChannel: "1481487113", eventType: "134068900600015603", content: content, push: nil) { [unowned self] (profile, error) -> Void in
            if let error = error {
                self.alert("Error occured!", message: error.localizedDescription)
                print(error)
                return
            }
            print(profile as Any)
        }
    }
    
    func uploadProfileImage() {
        adapter.getLineApiClient().uploadProfileImage(UIImage(named:"main_header_background"), lowQuality: false) { [unowned self] (result, error) -> Void in
            if let error = error {
                self.alert("Error occured!", message: error.localizedDescription)
                print(error)
                return
            }
            print(result as Any)
        }
    }
    
    
    
}


