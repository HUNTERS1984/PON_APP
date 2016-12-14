//
//  ChangePassViewController.swift
//  PonApp
//
//  Created by HaoLe on 12/9/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class ChangePassViewController: BaseViewController {

    @IBOutlet weak var currentPassTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passConfirmationTextField: UITextField!

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
        self.showBackButton()
        self.title = "パスワード変更"
        
        self.currentPassTextField.attributedPlaceholder = NSAttributedString(string:"現在パスワード", attributes:[NSForegroundColorAttributeName: UIColor(hex: DefaultPlaceHolderColor)])
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string:"新しいパスワード", attributes:[NSForegroundColorAttributeName: UIColor(hex: DefaultPlaceHolderColor)])
        self.passConfirmationTextField.attributedPlaceholder = NSAttributedString(string:"新しいパスワード(確認)", attributes:[NSForegroundColorAttributeName: UIColor(hex: DefaultPlaceHolderColor)])
    }
}

extension ChangePassViewController {
    
    @IBAction func changePassButtonPressed(_ sender: AnyObject) {
   
    }
    
}
