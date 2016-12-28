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
        self.getURL()
    }
    
}

extension TermsOfServiceViewController {
    
    fileprivate func getURL() {
        self.showHUD()
        ApiRequest.getSettingUrl("term") { [weak self] (request: URLRequest?, result: ApiResponse?, error: NSError?) in
            self?.hideHUD()
            if let _ = error {
                
            }else {
                if result?.code == SuccessCode {
                    if let _ = result?.data!["value"].string {
                        let url = result?.data!["value"].string
                        self?.contentWebView.loadRequest(URLRequest(url: URL(string: url!)!))
                    }
                }else {
                    self?.presentAlert(message: (result?.message)!)
                }
            }
        }
    }
    
}
