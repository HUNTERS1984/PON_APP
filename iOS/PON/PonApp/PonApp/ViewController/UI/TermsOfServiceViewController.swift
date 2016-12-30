//
//  TermsOfServiceViewController.swift
//  PonApp
//
//  Created by HaoLe on 9/27/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class TermsOfServiceViewController: BaseViewController {

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
        self.title = "利用規約"
        self.showBackButton()
    }
    
    override func setUpComponentsOnLoad() {
        super.setUpComponentsOnLoad()
        self.contentWebView.delegate = self
        self.contentWebView.loadRequest(URLRequest(url: URL(string: TermOfServiceUrl)!))
    }
    
}

extension TermsOfServiceViewController: UIWebViewDelegate {
    
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
