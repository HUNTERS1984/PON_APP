//
//  SignInViewController.swift
//  PonStaffApp
//
//  Created by HaoLe on 10/25/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class SignInViewController: BaseViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginActionView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        self.loginActionView.alpha = 0
        self.authorizeToken()
    }
    
}

//MARK: - IBAction
extension SignInViewController {
    
    @IBAction func signInButtonPressed(_ sender: AnyObject) {
        let userName = self.userNameTextField.text
        let password = self.passwordTextField.text
        
        self.validSignInInfomation(userName, password: password) { (successed: Bool, message: String) in
            if successed {
                self.signIn(userName!, password: password!)
            }else {
                self.presentAlert(message: message)
            }
        }
    }
}

//MARK: - Private
extension SignInViewController {
    
    func setupTabbarViewController() {
        let couponNavigationController: BaseNavigationController?
        let pointNavigationController: BaseNavigationController?
        
        var mainTabbarViewController: BaseTabBarController?
        
        let requestCouponVC = RequestCouponViewController.instanceFromStoryBoard("Main")
        couponNavigationController = BaseNavigationController(rootViewController: requestCouponVC!)
        
        let pointVC = PointViewController.instanceFromStoryBoard("Main")
        pointNavigationController = BaseNavigationController(rootViewController: pointVC!)
        
        
        mainTabbarViewController = BaseTabBarController()
        mainTabbarViewController?.viewControllers = [
            couponNavigationController!,
            pointNavigationController!
        ]
        mainTabbarViewController?.selectedIndex = 0
        mainTabbarViewController?.tabBar.isHidden = true
        self.appDelegate?.window?.rootViewController = mainTabbarViewController!
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
                    self.setupTabbarViewController()
                }else {
                    self.presentAlert(message: (result?.message)!)
                }
            }
        }
    }
    
    fileprivate func authorizeToken() {
        if let _ = Defaults[.token] {
            loggingPrint("Bearer \(Defaults[.token]!)")
            self.showHUD()
            ApiRequest.authorized { (request: URLRequest?, result: ApiResponse?, error: NSError?) in
                self.hideHUD()
                if let _ = error {
                    self.showActionView()
                }else {
                    if let _ = result {
                        if result!.code == SuccessCode {
                            UserDataManager.sharedInstance.loggedIn = true
                            UserDataManager.getUserProfile()
                            self.setupTabbarViewController()
                        }else {
                            self.showActionView()
                        }
                    }
                }
            }
        }else {
            self.showActionView()
        }
    }
    
    fileprivate func showActionView() {
        self.loginActionView.fadeIn(0.5)
    }
    
}
