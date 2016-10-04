//
//  SignInViewController.swift
//  PonApp
//
//  Created by HaoLe on 9/12/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class SignInViewController: BaseViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
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
    }

}

//MARK: - IBAction
extension SignInViewController {
    
    @IBAction func signInButtonPressed(_ sender: AnyObject) {
        let userName = self.userNameTextField.text
        let password = self.passwordTextField.text
        
        self.validInfomation(userName, password: password) { (successed: Bool, message: String) in
            if successed {
                self.signIn(userName!, password: password!)
            }else {
                
//                HLKAlertView.show("Error", message: message, cancelButtonTitle: "OK", otherButtonTitles: nil, handler: nil)
            }
        }
    }
    
    @IBAction func signUnButtonPressed(_ sender: AnyObject) {
        let vc = SignUpViewController.instanceFromStoryBoard("Register")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}

extension SignInViewController {
    
    fileprivate func validInfomation(_ userName: String?, password: String?, completion:(_ successed: Bool, _ message: String) -> Void) {
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
//                    HLKAlertView.show("Error", message: message, cancelButtonTitle: "OK", otherButtonTitles: nil, handler: nil)
                }
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
