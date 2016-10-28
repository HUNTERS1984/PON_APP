//
//  ShareCouponViewController.swift
//  PonApp
//
//  Created by HaoLe on 9/9/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class ShareCouponViewController: BaseViewController {

    public var code: String?
    
    @IBOutlet weak var actionViewBackgroundImageView: UIImageView!
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var lineButton: UIButton!
    @IBOutlet weak var qrCodeDisplayImageView: UIImageView!
    @IBOutlet weak var shareActionContainView: UIView!
    @IBOutlet weak var qrCodeContainView: UIView!
    
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
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        self.view.backgroundColor = UIColor.white
        self.actionViewBackgroundImageView.image = UIImage(named: "sns_button")
        self.instagramButton.setImage(UIImage(named: "coupon_instagram_button"), for: UIControlState())
        self.facebookButton.setImage(UIImage(named: "coupon_facebook_button"), for: UIControlState())
        self.twitterButton.setImage(UIImage(named: "coupon_twitter_button"), for: UIControlState())
        self.lineButton.setImage(UIImage(named: "coupon_line_button"), for: UIControlState())
        self.qrCodeContainView.alpha = 0.0
        self.displayQRCode()
    }

}

//MARK: - IBAction
extension ShareCouponViewController {
    
    @IBAction func qrCodeButtonPressed(_ sender: AnyObject) {
        self.actionViewBackgroundImageView.image = UIImage(named: "qr_code_button")
        self.shareActionContainView.fadeOut(0.5)
        self.qrCodeContainView.fadeIn(0.5)
    }
    
    @IBAction func snsButtonPressed(_ sender: AnyObject) {
        self.actionViewBackgroundImageView.image = UIImage(named: "sns_button")
        self.shareActionContainView.fadeIn(0.5)
        self.qrCodeContainView.fadeOut(0.5)
    }
    
    @IBAction func closeButttonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true)
    }
    
    @IBAction func instagramButtonPressed(_ sender: AnyObject) {
        ShareCouponManager.shared.postImageToInstagramWithCaption(imageInstagram: UIImage(named: "account_header_background")!, instagramCaption: "PON Test", view: self.view)
    }
    
    @IBAction func facebookButtonPressed(_ sender: AnyObject) {
        ShareCouponManager.shared.presentShareCouponToFacebook(self)
    }
    
    @IBAction func twitterButtonPressed(_ sender: AnyObject) {
        ShareCouponManager.shared.presentShareCouponToTwitter(self)
    }
    
    @IBAction func lineButtonPressed(_ sender: AnyObject) {
        LineLogin.shared.loginInApp(self)
    }
    
}

//MARK: - Private method
extension ShareCouponViewController {
    
    func displayQRCode() {
        if let _ = code {
            self.qrCodeDisplayImageView.image = QRCode.generateImage(code!, avatarImage: nil, avatarScale: 0.3)
        }
    }
    
}
