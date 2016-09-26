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
                HLKAlertView.show("", message: message, cancelButtonTitle: "OK", otherButtonTitles: nil, handler: nil)
            }
        }
    }
    
}

extension SignInViewController {
    
    private func setupTabbarViewController() {
        let mainNavigationController: BaseNavigationController?
        let accountNavigationController: BaseNavigationController?
        let favoriteNavigationController: BaseNavigationController?
        
        var mainTabbarViewController: BaseTabBarController?
        
        let mainViewController = MainViewController.instanceFromStoryBoard("Main")
        mainNavigationController = BaseNavigationController(rootViewController: mainViewController)
        
        let accountViewController = AccountViewController.instanceFromStoryBoard("Main")
        accountNavigationController = BaseNavigationController(rootViewController: accountViewController)
        
        let favoriteViewController = FavoriteViewController.instanceFromStoryBoard("Main")
        favoriteNavigationController = BaseNavigationController(rootViewController: favoriteViewController)
        
        
        mainTabbarViewController = BaseTabBarController()
        mainTabbarViewController?.viewControllers = [
            favoriteNavigationController!,
            mainNavigationController!,
            accountNavigationController!
        ]
        mainTabbarViewController?.selectedIndex = 1
        mainTabbarViewController?.tabBar.hidden = true
        self.appDelegate?.window?.rootViewController = mainTabbarViewController!
    }
    
    private func validInfomation(userName: String?, password: String?, completion:(successed: Bool, message: String) -> Void) {
        if let _ = userName {
            
        }else {
            completion(successed: false, message: "Please enter user name")
        }
        
        if let _ = password {
            
        }else {
            completion(successed: false, message: "Please enter password")
        }
        completion(successed: true, message: "")
    }
    
    private func signIn(userName: String, password: String) {
        self.showHUD()
        ApiRequest.signIn(userName, password: password) { (request: NSURLRequest?, result: ApiResponse?, error: NSError?) in
            self.hideHUD()
            if let _ = error {
                
            }else {
                if result?.code == 1000 {
                    if let token = result?.data!["token"].string {
                        Defaults[.token] = token
                    }
                    self.setupTabbarViewController()
                }else {
                    
                }
            }
        }
    }

}
