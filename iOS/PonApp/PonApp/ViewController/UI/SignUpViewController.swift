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
        
        self.validInfomation(userName, email: email, password: password) { (successed: Bool, message: String) in
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
    
    private func validInfomation(userName: String?, email: String?, password: String?, completion:(successed: Bool, message: String) -> Void) {
        if let _ = userName {
            
        }else {
            completion(successed: false, message: "Please enter user name")
        }
        
        if let _ = email {
            if !String.validate(email!) {
                completion(successed: false, message: "Please enter valid email")
            }
        }else {
            completion(successed: false, message: "Please enter email")
        }
        
        if let _ = password {
            
        }else {
            completion(successed: false, message: "Please enter password")
        }
        completion(successed: true, message: "")
    }
    
    private func registerUser(userName: String, email: String, password: String) {
        self.showHUD()
        ApiRequest.signUp(userName, email: email, password: password) { (request: NSURLRequest?, result: ApiResponse?, error: NSError?) in
            self.hideHUD()
            if let _ = error {
                
            }else {
                
            }
        }
    }
}
