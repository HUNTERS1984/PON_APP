//
//  ForgotPassViewController.swift
//  PonApp
//
//  Created by HaoLe on 12/14/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class ForgotPassViewController: BaseViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func setUpUserInterface() {
        super.setUpUserInterface()
        self.showCloseButton()
        self.emailTextField.attributedPlaceholder = NSAttributedString(string:"メールアドレス", attributes:[NSForegroundColorAttributeName: UIColor(hex: DefaultPlaceHolderColor)])
    }
    
    
}

extension ForgotPassViewController {
    
    @IBAction func sendButtonPressed(_ sender: Any) {
    }
    
    @IBAction override func navCloseButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true)
    }
    
}
