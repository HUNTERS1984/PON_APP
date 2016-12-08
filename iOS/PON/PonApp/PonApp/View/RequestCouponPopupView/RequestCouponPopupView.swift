//
//  AcceptPopupView.swift
//  PonStaffApp
//
//  Created by HaoLe on 10/27/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class RequestCouponPopupView: PopupView {
    
    @IBOutlet weak var qrcodeImage: UIImageView!

    let scanner = QRCode()
    
    open var coupon: Coupon! {
        didSet {
            
        }
    }
    
    public static func create() -> RequestCouponPopupView {
        let popup = self.loadViewFromNib() as! RequestCouponPopupView
        popup.frame = UIScreen.main.bounds
        return popup
    }
    
    @IBAction func donetButtonPressed(_ sender: AnyObject) {
        self.doneButtonPressed?()
    }
    
    fileprivate func showQRCode() {
        if let _ = coupon.code {
            self.qrcodeImage.image = QRCode.generateImage(coupon.code!, avatarImage: nil, avatarScale: 0.3)
        }
    }
    override func showPopup(inView view: UIView, animated: Bool) {
        super.showPopup(inView: view, animated: animated)
        self.showQRCode()
    }
    
}
