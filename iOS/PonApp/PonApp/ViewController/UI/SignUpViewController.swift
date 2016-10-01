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
    
    override func viewWillAppear(animated: Bool) {
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
    
    @IBAction func signupButtonPressed(sender: AnyObject) {
        let userName = self.userNameTextField.text
        let email = self.emailTextField.text
        let password = self.passwordTextField.text
        let confimPassowrd = self.passConfirmationTextField.text
        
        self.validInfomation(userName, email: email, password: password, confirmPassword: confimPassowrd) { (successed: Bool, message: String) in
            if successed {
                self.registerUser(userName!, email: email!, password: password!)
            }else {
                HLKAlertView.show("", message: message, cancelButtonTitle: "OK", otherButtonTitles: nil, handler: nil)
            }
        }
    }
    
}

//MARK: - Private
extension SignUpViewController {
    
    private func validInfomation(userName: String?, email: String?, password: String?, confirmPassword: String?, completion:(successed: Bool, message: String) -> Void) {
        if let _ = userName {
            
        }else {
            completion(successed: false, message: UserNameBlank)
        }
        
        if let _ = email {
            if !String.validate(email!) {
                completion(successed: false, message: EmailNotValid)
            }
        }else {
            completion(successed: false, message: EmailBlank)
        }
        
        if let _ = password {
            if password!.characters.count < 6 {
                completion(successed: false, message: PasswordRange)
            }
        }else {
            completion(successed: false, message: PasswordBlank)
        }
        
        if let _ = confirmPassword {
            if confirmPassword! != confirmPassword! {
                completion(successed: false, message: PasswordNotMatch)
            }
        }else {
            completion(successed: false, message: PasswordNotMatch)
        }
        
        completion(successed: true, message: "")
    }
    
    private func registerUser(userName: String, email: String, password: String) {
        self.showHUD()
        ApiRequest.signUp(userName, email: email, password: password) { (request: NSURLRequest?, result: ApiResponse?, error: NSError?) in
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
                    HLKAlertView.show("Error", message: result?.message, cancelButtonTitle: "OK", otherButtonTitles: nil, handler: nil)
                }
            }
        }
    }
}
