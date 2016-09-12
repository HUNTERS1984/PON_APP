//
//  ShareCouponViewController.swift
//  PonApp
//
//  Created by HaoLe on 9/9/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class ShareCouponViewController: BaseViewController {

    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var lineButton: UIButton!
    
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
        self.instagramButton.setImage(UIImage(named: "coupon_instagram_button"), forState: .Normal)
        self.facebookButton.setImage(UIImage(named: "coupon_facebook_button"), forState: .Normal)
        self.twitterButton.setImage(UIImage(named: "coupon_twitter_button"), forState: .Normal)
        self.lineButton.setImage(UIImage(named: "coupon_line_button"), forState: .Normal)
    }

}

//MARK: - IBAction
extension ShareCouponViewController {
    
    @IBAction func closeButttonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(false)
    }
    
    @IBAction func snsButtonPressed(sender: AnyObject) {
    }
    
    @IBAction func qrCodePressed(sender: AnyObject) {
    }
    
    @IBAction func instagramButtonPressed(sender: AnyObject) {
    }
    
    @IBAction func facebookButtonPressed(sender: AnyObject) {
    }
    
    @IBAction func twitterButtonPressed(sender: AnyObject) {
    }
    
    @IBAction func lineButtonPressed(sender: AnyObject) {
    }
    
}