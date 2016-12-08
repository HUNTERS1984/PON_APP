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
        let authURL = InstagramEngine.shared().authorizationURL()
        self.webView.loadRequest(URLRequest(url: authURL))
        
        self.title = "Instagram"
        let button = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelButtonPressed(_: )))
        self.navigationItem.leftBarButtonItem = button
    }
    
    @IBAction func cancelButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

}

extension InstagramLoginViewController: UIWebViewDelegate {
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        do {
            try InstagramEngine.shared().receivedValidAccessToken(from: request.url!)
            print(InstagramEngine.shared().accessToken!)
        }catch {
            
        }
        return true
    }
    
}
