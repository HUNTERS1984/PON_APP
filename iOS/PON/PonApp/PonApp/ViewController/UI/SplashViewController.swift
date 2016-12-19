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
    @IBOutlet weak var backButton: UIButton!
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func startGoogleAnalytics() {
        super.startGoogleAnalytics()
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: GAScreen_Splash)
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        self.backgroundImageView.image = UIImage(named: "splash_background")
        self.view.sendSubview(toBack: self.backgroundImageView)
        self.backButton.setImage(UIImage(named: "nav_back"), for: UIControlState())
        self.facebookButton.setImage(UIImage(named: "splash_button_facebook"), for: UIControlState())
        self.twitterButton.setImage(UIImage(named: "splash_button_twitter"), for: UIControlState())
        self.mailButton.setImage(UIImage(named: "splash_button_email"), for: UIControlState())
        self.skipButton.setImage(UIImage(named: "splash_button_skip"), for: UIControlState())
        self.loginButton.setImage(UIImage(named: "splash_button_login"), for: UIControlState())
        
        self.loginActionView.alpha = 0
        self.actionView.alpha = 0
        self.backButton.alpha = 0
        self.authorizeToken()
    }
    
}

//MARK: - IBAction
extension SplashViewController {
    
    @IBAction override func backButtonPressed(_ sender: AnyObject) {
        self.backButton.alpha = 0
        self.actionView.fadeIn(0.5)
        self.loginActionView.fadeOut(0.5)
    }
    
    @IBAction func facebookButtonPressed(_ sender: AnyObject) {
        FacebookLogin.logInWithReadPermissions(["public_profile", "email"], fromViewController: self) { (result: [String: String]?, error: Error?) in
            if let _ = error {
                print(error!)
            }else {
                loggingPrint(result)
                let accessToken = result!["token"]
                self.signInWithFacebook(accessToken!)
            }
        }
    }
    
    @IBAction func twitterButtonPressed(_ sender: AnyObject) {
        TwitterLogin.loginViewControler(self) { (success: Bool, result: Any?) in
            if success {
                if let _ = result {
                    let session = result as! TWTRSession
                    let token = session.authToken
                    let tokenSecret = session.authTokenSecret
                    self.signInWithTwitter(token, tokenSecret: tokenSecret)
                } else {
                    let error = result as! NSError
                    loggingPrint("Login error: %@", error.localizedDescription);
                }
            }else {
                
            }
        }
    }
    
    @IBAction func mailButtonPressed(_ sender: AnyObject) {
        let vc = SignInViewController.instanceFromStoryBoard("Register")
        let nav = UINavigationController.init(rootViewController: vc!)
        self.navigationController!.present(nav, animated: true)
    }
    
    @IBAction func skipButtonPressed(_ sender: AnyObject) {
        UserDataManager.shared.loggedIn = false
        self.setupTabbarViewController()
    }
    
    @IBAction func loginActionButtonPressed(_ sender: AnyObject) {
        self.backButton.alpha = 1.0
        self.actionView.fadeOut(0.5)
        self.loginActionView.fadeIn(0.5)
    }
    
}

//MARK: - Private methods
extension SplashViewController {
    
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
                            UserDataManager.shared.loggedIn = true
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
        self.actionView.fadeIn(0.5)
        self.loginActionView.fadeOut(0.5)
    }
    
    fileprivate func signInWithFacebook(_ accessToken: String) {
        self.showHUD()
        ApiRequest.signInFacebook(accessToken) { (request: URLRequest?, result: ApiResponse?, error: NSError?) in
            self.hideHUD()
            if let _ = error {
                
            }else {
                if result?.code == SuccessCode {
                    if let token = result?.data!["token"].string {
                        Defaults[.token] = token
                    }
                    UserDataManager.shared.loggedIn = true
                    UserDataManager.shared.isSocialLogin = true
                    UserDataManager.getUserProfile()
                    self.setupTabbarViewController()
                }else {
                    self.presentAlert(message: (result?.message)!)
                }
            }
        }
    }
    
    fileprivate func signInWithTwitter(_ token: String, tokenSecret: String) {
        self.showHUD()
        ApiRequest.signInTwitter(token, tokenSecret: tokenSecret) { (request: URLRequest?, result: ApiResponse?, error: NSError?) in
            self.hideHUD()
            if let _ = error {
                
            }else {
                if result?.code == SuccessCode {
                    if let token = result?.data!["token"].string {
                        Defaults[.token] = token
                    }
                    UserDataManager.shared.loggedIn = true
                    UserDataManager.shared.isSocialLogin = true
                    UserDataManager.getUserProfile()
                    self.setupTabbarViewController()
                }else {
                    self.presentAlert(message: (result?.message)!)
                }
            }
        }
    }
    
}
