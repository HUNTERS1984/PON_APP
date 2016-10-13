//
//  NewsDetailViewController.swift
//  PonApp
//
//  Created by HaoLe on 10/13/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class NewsDetailViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationManager.shared.clearNotification()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        self.showBackButton()
    }

}
