//
//  InstagramLoginViewController.swift
//  PonApp
//
//  Created by HaoLe on 9/20/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit
import InstagramKit

class InstagramLoginViewController: BaseViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        let authURL = InstagramEngine.sharedEngine().authorizationURL()
        self.webView.loadRequest(NSURLRequest(URL: authURL))
        
        self.title = "Instagram"
        let button = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(self.cancelButtonPressed(_: )))
        self.navigationItem.leftBarButtonItem = button
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}

extension InstagramLoginViewController: UIWebViewDelegate {
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        do {
            try InstagramEngine.sharedEngine().receivedValidAccessTokenFromURL(request.URL!)
        }catch {
            
        }
        return true
    }
    
}
