//
//  ShareCouponViewController.swift
//  PonApp
//
//  Created by HaoLe on 9/9/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class ShareCouponViewController: BaseViewController {
    @IBOutlet weak var actionViewBackgroundImageView: UIImageView!
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var lineButton: UIButton!
    @IBOutlet weak var qrCodeDisplayImageView: UIImageView!
    @IBOutlet weak var shareActionContainView: UIView!
    @IBOutlet weak var qrCodeContainView: UIView!
    
    public var code: String?
    var coupon: Coupon? = nil
    
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
        //self.lineButton.isHidden = true
        self.displayQRCode()
    }

}

//MARK: - IBAction
extension ShareCouponViewController {
    
    @IBAction func qrCodeButtonPressed(_ sender: AnyObject) {
        if let _ = code {
            self.actionViewBackgroundImageView.image = UIImage(named: "qr_code_button")
            self.shareActionContainView.fadeOut(0.5)
            self.qrCodeContainView.fadeIn(0.5)
        }else {
            self.presentAlert(message: QRCodeUnavailable)
        }
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
        PonImageDownloader.shared.downloadImage(self.coupon!.imageURL!, completion: { (_ result: UIImage?, _ error: NSError?) in
            self.hideHUD()
            if let _ = result {
                ShareCouponManager.shared.postImageToInstagramWithCaption(imageInstagram: result!, instagramCaption: "PON", view: self.view)
            } else {
                
            }
        })
    }
    
    @IBAction func facebookButtonPressed(_ sender: AnyObject) {
        if let _ = self.coupon!.link {
            ShareCouponManager.shared.presentShareCouponToFacebook(self, initialText: "", url: self.coupon!.link!, image: nil)
        }
    }
    
    @IBAction func twitterButtonPressed(_ sender: AnyObject) {
        self.shareTwitter()
    }
    
    @IBAction func lineButtonPressed(_ sender: AnyObject) {
        self.shareLINE()
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

//MARK: - SNS
extension ShareCouponViewController {

    fileprivate func shareLINE() {
        self.view.endEditing(true)
        if SNSShare.isLineInstalled() {
            self.showHUD()
            var images = [UIImage]()
            PonImageDownloader.shared.downloadImage(self.coupon!.imageURL!, completion: { (_ result: UIImage?, _ error: NSError?) in
                self.hideHUD()
                if let _ = result {
                    images.append(result!)
                } else {
                    
                }
                let urls = [URL(string: self.coupon!.lineSharing!)!]
                let shareText = self.coupon!.lineHashTag!
                let data = SNSShareData(text: shareText, images: images, urls: urls)
                SNSShare.post(type: .line, data: data, controller: self, completion: { result in
                    switch result {
                    case .success:
                        print("Posted!!")
                    case .failure(let error):
                        print(error)
                    }
                })
            })
        }else {
            UIAlertController.present(title: "", message: InstallLine, actionTitles: [OK])
        }
        
    }
    
     fileprivate func shareTwitter() {
        self.view.endEditing(true)
        self.showHUD()
        var images = [UIImage]()
        PonImageDownloader.shared.downloadImage(self.coupon!.imageURL!, completion: { (_ result: UIImage?, _ error: NSError?) in
            self.hideHUD()
            if let _ = result {
                images.append(result!)
            } else {
                
            }
            let urls = [URL(string: self.coupon!.twitterSharing!)!]
            let shareText = self.coupon!.twitterHashtag!
            let data = SNSShareData(text: shareText, images: images, urls: urls)
            SNSShare.post(type: .twitter, data: data, controller: self, completion: { result in
                switch result {
                case .success:
                    print("Posted!!")
                case .failure(let et):
                    print(et)
                }
            })
        })
    }
    
}
