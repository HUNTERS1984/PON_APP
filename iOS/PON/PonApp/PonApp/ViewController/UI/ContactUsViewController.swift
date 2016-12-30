//
//  ContactUsViewController.swift
//  PonApp
//
//  Created by HaoLe on 12/27/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class ContactUsViewController: BaseViewController {

    @IBOutlet weak var contentWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        self.title = "お問い合わせ"
        self.showBackButton()
    }
    

    override func setUpComponentsOnLoad() {
        super.setUpComponentsOnLoad()
        self.contentWebView.delegate = self
        self.contentWebView.loadRequest(URLRequest(url: URL(string: ContactUsUrl)!))
    }
    
}


extension ContactUsViewController: UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.showHUD()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.hideHUD()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.hideHUD()
    }
    
}
