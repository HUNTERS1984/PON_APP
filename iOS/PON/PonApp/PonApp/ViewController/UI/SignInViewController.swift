//
//  SignInViewController.swift
//  PonApp
//
//  Created by HaoLe on 9/12/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class SignInViewController: BaseViewController {

    @IBOutlet weak var registerContainerView: UIView!
    @IBOutlet weak var loginContainerView:UIView!
    
    //MARK: Login Outlet
    @IBOutlet weak var lguserNameTextField: UITextField!
    @IBOutlet weak var lgpasswordTextField: UITextField!
    
    //MARK: Register Outlet
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passConfirmationTextField: UITextField!
    
    var loginState: LoginState = .normal
    
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
        self.title = "ログイン"
        self.showCloseButton()
        self.registerContainerView.alpha = 0
        
        //setup login form
        self.lguserNameTextField.attributedPlaceholder = NSAttributedString(string:"メールアドレス", attributes:[NSForegroundColorAttributeName: UIColor(hex: DefaultPlaceHolderColor)])
        self.lgpasswordTextField.attributedPlaceholder = NSAttributedString(string:"パスワード", attributes:[NSForegroundColorAttributeName: UIColor(hex: DefaultPlaceHolderColor)])
        
        //setup register form
        self.userNameTextField.attributedPlaceholder = NSAttributedString(string:"ユーザーネーム", attributes:[NSForegroundColorAttributeName: UIColor(hex: DefaultPlaceHolderColor)])
        self.emailTextField.attributedPlaceholder = NSAttributedString(string:"メールアドレス", attributes:[NSForegroundColorAttributeName: UIColor(hex: DefaultPlaceHolderColor)])
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string:"パスワード", attributes:[NSForegroundColorAttributeName: UIColor(hex: DefaultPlaceHolderColor)])
        self.passConfirmationTextField.attributedPlaceholder = NSAttributedString(string:"パスワード（確認）", attributes:[NSForegroundColorAttributeName: UIColor(hex: DefaultPlaceHolderColor)])

    }

}

//MARK: - IBAction
extension SignInViewController {
    
    @IBAction func signInButtonPressed(_ sender: AnyObject) {
        let userName = self.lguserNameTextField.text
        let password = self.lgpasswordTextField.text
        
        self.validSignInInfomation(userName, password: password) { (successed: Bool, message: String) in
            if successed {
                self.signIn(userName!, password: password!)
            }else {
                self.presentAlert(message: message)
            }
        }
    }
    
    @IBAction func showSignUpFormButtonPressed(_ sender: AnyObject) {
        self.showSignUpForm()
    }
    
    @IBAction func signUpButtonPressed(_ sender: AnyObject) {
        let userName = self.userNameTextField.text
        let email = self.emailTextField.text
        let password = self.passwordTextField.text
        let confimPassowrd = self.passConfirmationTextField.text
        
        self.validSignUpInfomation(userName, email: email, password: password, confirmPassword: confimPassowrd) { (successed: Bool, message: String) in
            if successed {
                self.registerUser(userName!, email: email!, password: password!)
            }else {
                self.presentAlert(message: message)
            }
        }
    }
    
    @IBAction override func navCloseButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true)
    }
    
    @IBAction func accountAlreadyButtonPressed(_ sender: AnyObject) {
        self.showLoginForm()
    }

}

extension SignInViewController {
    
    fileprivate func showLoginForm() {
        self.title = "ログイン"
        self.registerContainerView.fadeOut(0.5)
        self.loginContainerView.fadeIn(0.5)
    }
    
    fileprivate func showSignUpForm() {
        self.title = "新規会員登録"
        self.registerContainerView.fadeIn(0.5)
        self.loginContainerView.fadeOut(0.5)
    }
    
    fileprivate func validSignInInfomation(_ userName: String?, password: String?, completion:(_ successed: Bool, _ message: String) -> Void) {
        if let _ = userName {
            
        }else {
            completion(false, UserNameBlank)
            return
        }
        
        if let _ = password {

        }else {
            completion(false, PasswordBlank)
            return
        }
        completion(true, "")
    }
    
    fileprivate func signIn(_ userName: String, password: String) {
        self.showHUD()
        ApiRequest.signIn(userName, password: password) { (request: URLRequest?, result: ApiResponse?, error: NSError?) in
            self.hideHUD()
            if let _ = error {
                let message = error!.userInfo["error"] as? String
                if let _ = message {
                    self.presentAlert(message: message!)
                }
            }else {
                if result?.code == SuccessCode {
                    if let token = result?.data!["token"].string {
                        Defaults[.token] = token
                    }
                    UserDataManager.sharedInstance.loggedIn = true
                    UserDataManager.getUserProfile()
                    if self.loginState == .normal {
                        self.setupTabbarViewController()
                    }
                    self.dismiss(animated: true)
                }else {
                    self.presentAlert(message: (result?.message)!)
                }
            }
        }
    }
    
    fileprivate func validSignUpInfomation(_ userName: String?, email: String?, password: String?, confirmPassword: String?, completion:(_ successed: Bool, _ message: String) -> Void) {
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
                    if self.loginState == .normal {
                        self.setupTabbarViewController()
                        self.dismiss(animated: true)
                    }
                }else {
                    self.presentAlert(message: (result?.message)!)
                }
            }
        }
    }

}
