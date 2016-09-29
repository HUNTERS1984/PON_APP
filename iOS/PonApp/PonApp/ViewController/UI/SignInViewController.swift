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
    
    override func viewWillAppear(animated: Bool) {
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
    
    @IBAction func signInButtonPressed(sender: AnyObject) {
        let userName = self.userNameTextField.text
        let password = self.passwordTextField.text
        
        self.validInfomation(userName, password: password) { (successed: Bool, message: String) in
            if successed {
                self.signIn(userName!, password: password!)
            }else {
                HLKAlertView.show("Error", message: message, cancelButtonTitle: "OK", otherButtonTitles: nil, handler: nil)
            }
        }
    }
    
    @IBAction func signUnButtonPressed(sender: AnyObject) {
        let vc = SignUpViewController.instanceFromStoryBoard("Register")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension SignInViewController {
    
    private func validInfomation(userName: String?, password: String?, completion:(successed: Bool, message: String) -> Void) {
        if let _ = userName {
            
        }else {
            completion(successed: false, message: "Username not valid")
        }
        
        if let _ = password {
            
        }else {
            completion(successed: false, message: "Password not valid")
        }
        completion(successed: true, message: "")
    }
    
    private func signIn(userName: String, password: String) {
        self.showHUD()
        ApiRequest.signIn(userName, password: password) { (request: NSURLRequest?, result: ApiResponse?, error: NSError?) in
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
