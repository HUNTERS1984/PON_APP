//
//  ForgotPassViewController.swift
//  PonApp
//
//  Created by HaoLe on 12/14/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

protocol ForgotPassViewControllerDelegate: class {
    func forgotPassViewController(_ viewController: ForgotPassViewController, didSendRequestNewPassword state: Bool)
}

class ForgotPassViewController: BaseViewController {

    @IBOutlet weak var emailTextField: UITextField!
    weak var handler: ForgotPassViewControllerDelegate? = nil
    
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
        let email = self.emailTextField.text
        validInfomation(email) { (successed: Bool, message: String) in
            if successed {
               requestForgotPassword(email!)
            }else {
                self.presentAlert(message: message)
            }
        }
    }
    
    @IBAction override func navCloseButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true)
    }
    
}

extension ForgotPassViewController {
    
    fileprivate func validInfomation(_ email: String?, completion:(_ successed: Bool, _ message: String) -> Void) {
        if let _ = email {
            if email!.characters.count == 0 {
                completion(false, EmailBlank)
                return
            }
        }else {
            completion(false, EmailBlank)
            return
        }
        completion(true, "")
    }
    
    fileprivate func requestForgotPassword(_ email: String) {
        self.showHUD()
        ApiRequest.forgotPassword(email) { [weak self] (request: URLRequest?, result: ApiResponse?, error: NSError?) in
            self?.hideHUD()
            if let _ = error {
                
            }else {
                if result?.code == SuccessCode {
                    self?.handler?.forgotPassViewController(self!, didSendRequestNewPassword: true)
                }else {
                    self?.presentAlert(message: (result?.message)!)
                }
            }
        }
    }
    
}
