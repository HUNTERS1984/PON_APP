//
//  SplashViewController.swift
//  PonApp
//
//  Created by OSXVN on 9/2/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import TwitterKit

class SplashViewController: BaseViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var loginActionView: UIView!
    @IBOutlet weak var actionView: UIView!
    @IBOutlet weak var sloganLabel: UILabel!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var mailButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        self.backgroundImageView.image = UIImage(named: "splash_background")
        self.view.sendSubviewToBack(self.backgroundImageView)
        self.facebookButton.setImage(UIImage(named: "splash_button_facebook"), forState: .Normal)
        self.twitterButton.setImage(UIImage(named: "splash_button_twitter"), forState: .Normal)
        self.mailButton.setImage(UIImage(named: "splash_button_email"), forState: .Normal)
        self.skipButton.setImage(UIImage(named: "splash_button_skip"), forState: .Normal)
        self.loginButton.setImage(UIImage(named: "splash_button_login"), forState: .Normal)
        
        self.loginActionView.alpha = 0
        self.actionView.alpha = 0
        self.authorizeToken()
    }
    
}

//MARK: - IBAction
extension SplashViewController {
    
    @IBAction func facebookButtonPressed(sender: AnyObject) {
        FacebookLogin.logInWithReadPermissions(["public_profile", "email"], fromViewController: self) { (result: FBSDKLoginManagerLoginResult!, error: NSError!) in
            
        }
    }
    
    @IBAction func twitterButtonPressed(sender: AnyObject) {
        TwitterLogin.loginViewControler(self) { (success: Bool, result: Any?) in
            if success {
                if let _ = result {
                    let session = result as! TWTRSession
                    let alert = UIAlertView(title: "Logged In", message: "User \(session.userName) has logged in", delegate: nil, cancelButtonTitle: "OK")
                    alert.show()
                } else {
                    let error = result as! NSError
                    print("Login error: %@", error.localizedDescription);
                }
            }else {
                
            }
        }
    }
    
    @IBAction func mailButtonPressed(sender: AnyObject) {
        let vc = SignInViewController.instanceFromStoryBoard("Register")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func skipButtonPressed(sender: AnyObject) {
        UserDataManager.sharedInstance.loggedIn = false
        self.setupTabbarViewController()
    }
    
    @IBAction func loginActionButtonPressed(sender: AnyObject) {
        self.actionView.fadeOut(0.5)
        self.loginActionView.fadeIn(0.5)
    }
    
}

//MARK: - Private methods
extension SplashViewController {
    
    private func authorizeToken() {
        if let _ = Defaults[.token] {
            print("Bearer \(Defaults[.token]!)")
            self.showHUD()
            ApiRequest.authorized { (request: NSURLRequest?, result: ApiResponse?, error: NSError?) in
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
                            HLKAlertView.show("Error", message: result?.message, cancelButtonTitle: "OK", otherButtonTitles: nil, handler: nil)
                        }
                    }
                }
            }
        }else {
            self.showActionView()
        }
    }
    
    private func showActionView() {
        self.actionView.fadeIn(0.5)
        self.loginActionView.fadeOut(0.5)
    }
    
    
}
