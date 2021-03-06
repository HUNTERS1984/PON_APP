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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func startGoogleAnalytics() {
        super.startGoogleAnalytics()
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: GAScreen_LoginEmail)
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
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
    
    @IBAction func forgotPassButtonPressed(_ sender: AnyObject) {
        let vc = ForgotPassViewController.instanceFromStoryBoard("Register") as! ForgotPassViewController
        vc.handler = self
        let nav = UINavigationController.init(rootViewController: vc)
        self.navigationController!.present(nav, animated: true)
    }
}

extension SignInViewController {
    
    fileprivate func showLoginForm() {
        self.title = "ログイン"
        
        lguserNameTextField.text = ""
        lgpasswordTextField.text = ""
        

        self.registerContainerView.fadeOut(0.5)
        self.loginContainerView.fadeIn(0.5)
    }
    
    fileprivate func showSignUpForm() {
        self.title = "新規会員登録"
        
        userNameTextField.text = ""
        emailTextField.text = ""
        passwordTextField.text = ""
        passConfirmationTextField.text = ""
        
        self.registerContainerView.fadeIn(0.5)
        self.loginContainerView.fadeOut(0.5)
    }
    
    fileprivate func validSignInInfomation(_ userName: String?, password: String?, completion:(_ successed: Bool, _ message: String) -> Void) {
        if let _ = userName {
            if userName!.characters.count == 0 {
                completion(false, UserNameBlank)
                return
            }
        }else {
            completion(false, UserNameBlank)
            return
        }
        
        if let _ = password {
            if password!.characters.count == 0 {
                completion(false, PasswordBlank)
                return
            }
        }else {
            completion(false, PasswordBlank)
            return
        }
        completion(true, "")
    }
    
    fileprivate func signIn(_ userName: String, password: String) {
        self.showHUD()
        ApiRequest.signIn(userName, password: password) { [weak self] (request: URLRequest?, result: ApiResponse?, error: NSError?) in
            self?.hideHUD()
            if let _ = error {
                let message = error!.userInfo["error"] as? String
                if let _ = message {
                    self?.presentAlert(message: message!)
                }
            }else {
                if result?.code == SuccessCode {
                    if let token = result?.data!["token"].string {
                        Defaults[.token] = token
                    }
                    UserDataManager.shared.loggedIn = true
                    Defaults[.snsLogin] = false
                    UserDataManager.shared.setUserData(result?.data)
                    UserDataManager.getUserProfile()
                    if self?.loginState == .normal {
                        self?.setupTabbarViewController()
                    }
                    self?.dismiss(animated: true)
                }else {
                    self?.presentAlert(message: (result?.message)!)
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
        ApiRequest.signUp(userName, email: email, password: password) { [weak self] (request: URLRequest?, result: ApiResponse?, error: NSError?) in
            self?.hideHUD()
            if let _ = error {
                
            }else {
                if result?.code == SuccessCode {
                    if let token = result?.data!["token"].string {
                        Defaults[.token] = token
                    }
                    UserDataManager.shared.loggedIn = true
                    Defaults[.snsLogin] = false
                    UserDataManager.shared.setUserData(result?.data)
                    UserDataManager.getUserProfile()
                    if self?.loginState == .normal {
                        self?.setupTabbarViewController()
                        self?.dismiss(animated: true)
                    }
                }else {
                    self?.presentAlert(message: (result?.message)!)
                }
            }
        }
    }

}

extension SignInViewController: ForgotPassViewControllerDelegate {
    
    func forgotPassViewController(_ viewController: ForgotPassViewController, didSendRequestNewPassword state: Bool) {
        if state {
            viewController.dismiss(animated: true, completion: { 
                self.presentAlert(with: "", message: "Your password reset request successed. Check your email to create new password")
            })
        }
    }
}
