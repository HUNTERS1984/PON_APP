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
    
    @IBOutlet weak var couponContentView: DesignableView!
    @IBOutlet weak var confirmView: DesignableView!
    @IBOutlet weak var thumbImageView: UIImageView!
    
    var coupon: Coupon! {
        didSet {
            self.setDataForCell(coupon)
        }
    }
    
    func setDataForCell(coupon: Coupon) {
        let URL = NSURL(string: coupon.imageURL)!
        self.thumbImageView.af_setImageWithURL(URL)
    }
}
