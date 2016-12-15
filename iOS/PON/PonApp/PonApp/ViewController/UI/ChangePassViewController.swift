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
        let oldPass = self.currentPassTextField.text
        let newPass = self.passwordTextField.text
        let confimPassowrd = self.passConfirmationTextField.text
        
        self.validInfomation(oldPass, newPass: newPass, confirmPass: confimPassowrd) { (successed: Bool, message: String) in
            if successed {
                self.changePassword(oldPass, newPass: newPass, confirmPass: confimPassowrd)
            }else {
                self.presentAlert(message: message)
            }
        }
    }
    
}

extension ChangePassViewController {
    
    fileprivate func validInfomation(_ oldPass: String?, newPass: String?, confirmPass: String?, completion:(_ successed: Bool, _ message: String) -> Void) {
        if let _ = oldPass {
            if oldPass!.characters.count == 0 {
                completion(false, PasswordBlank)
                return
            }
        }else {
            completion(false, PasswordBlank)
            return
        }
        
        if let _ = newPass {
            if newPass!.characters.count < 6 {
                completion(false, PasswordRange)
                return
            }
        }else {
            completion(false, PasswordBlank)
            return
        }
        
        if let _ = confirmPass {
            if newPass! != confirmPass! {
                completion(false, PasswordNotMatch)
                return
            }
        }else {
            completion(false, PasswordNotMatch)
            return
        }
        
        completion(true, "")
    }
    
    fileprivate func changePassword(_ oldPass: String?, newPass: String?, confirmPass: String?) {
        self.showHUD()
        ApiRequest.changePassword(oldPass!, newPass: newPass!, confirmPass: confirmPass!) { [weak self] (request: URLRequest?, result: ApiResponse?, error: NSError?) in
            self?.hideHUD()
            if let _ = error {
                
            }else {
                if result?.code == SuccessCode {
                    UIAlertController.present(title: "", message: ChangePassSuccesed, actionTitles: [OK]) { (action) -> () in
                        if action.title == "OK" {
                            _ = self?.navigationController?.popViewController(animated: true)
                        }
                    }
                }else {
                    self?.presentAlert(message: (result?.message)!)
                }
            }
        }
    }
    
}
