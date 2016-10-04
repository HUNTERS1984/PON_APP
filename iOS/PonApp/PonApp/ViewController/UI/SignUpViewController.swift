//
//  SignUpViewController.swift
//  PonApp
//
//  Created by HaoLe on 9/12/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class SignUpViewController: BaseViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passConfirmationTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        self.title = "新規会員登録"
        self.showCloseButton()
    }

}


//MARK: - IBAction
extension SignUpViewController {
    
    @IBAction func signupButtonPressed(_ sender: AnyObject) {
        let userName = self.userNameTextField.text
        let email = self.emailTextField.text
        let password = self.passwordTextField.text
        let confimPassowrd = self.passConfirmationTextField.text
        
        self.validInfomation(userName, email: email, password: password, confirmPassword: confimPassowrd) { (successed: Bool, message: String) in
            if successed {
                self.registerUser(userName!, email: email!, password: password!)
            }else {
//                HLKAlertView.show("Error", message: message, cancelButtonTitle: "OK", otherButtonTitles: nil, handler: nil)
            }
        }
    }
    
}

//MARK: - Private
extension SignUpViewController {
    
    fileprivate func validInfomation(_ userName: String?, email: String?, password: String?, confirmPassword: String?, completion:(_ successed: Bool, _ message: String) -> Void) {
        if let _ = userName {
            if userName!.characters.count == 0 {
                completion(false, UserNameBlank)
                return
            }
        }else {
            completion(false, UserNameBlank)
            return
        }
        
        if let _ = email {
            if !String.validate(email!) {
                completion(false, EmailNotValid)
                return
            }
        }else {
            completion(false, EmailBlank)
            return
        }
        
        if let _ = password {
            if password!.characters.count < 6 {
                completion(false, PasswordRange)
                return
            }
        }else {
            completion(false, PasswordBlank)
            return
        }
        
        if let _ = confirmPassword {
            if password! != confirmPassword! {
                completion(false, PasswordNotMatch)
                return
            }
        }else {
            completion(false, PasswordNotMatch)
            return
        }
        
        completion(true, "")
    }
    
    fileprivate func registerUser(_ userName: String, email: String, password: String) {
        self.showHUD()
        ApiRequest.signUp(userName, email: email, password: password) { (request: URLRequest?, result: ApiResponse?, error: NSError?) in
            self.hideHUD()
            if let _ = error {
                
            }else {
                if result?.code == SuccessCode {
                    if let token = result?.data!["token"].string {
                        Defaults[.token] = token
                    }
                    UserDataManager.sharedInstance.loggedIn = true
                    UserDataManager.getUserProfile()
                    self.setupTabbarViewController()
                }else {
//                    HLKAlertView.show("Error", message: result?.message, cancelButtonTitle: "OK", otherButtonTitles: nil, handler: nil)
                }
            }
        }
    }
}
