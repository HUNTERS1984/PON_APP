//
//  CouponCollectionViewCell.swift
//  PonApp
//
//  Created by HaoLe on 9/5/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit
import AlamofireImage

class CouponCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var confirmView: DesignableView!
    
    @IBOutlet weak var couponContentView: DesignableView!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var expireDateLabel: UILabel!
    @IBOutlet weak var likeIconImage: UIImageView!
    @IBOutlet weak var usedIconImage: UIImageView!
    
    var coupon: Coupon! {
        didSet {
            self.setDataForCell(self.coupon)
        }
    }
    
    func setDataForCell(coupon: Coupon) {
        if coupon.showConfirmView {
            self.confirmView.hidden = false
            self.couponContentView.hidden = true
        }else {
            self.confirmView.hidden = true
            self.couponContentView.hidden = false
        }
        
        self.usedIconImage.hidden = !coupon.isUsed
        let URL = NSURL(string: coupon.imageURL)!
        self.thumbImageView.af_setImageWithURL(URL)
        self.titleLabel.text = coupon.title
        self.expireDateLabel.text = coupon.expiryDate
        if let _ = coupon.isLike {
            self.likeIconImage.hidden = !coupon.isLike
        }else {
            self.likeIconImage.hidden = true
        }
        self.typeLabel.text = coupon.couponType
    }
}
