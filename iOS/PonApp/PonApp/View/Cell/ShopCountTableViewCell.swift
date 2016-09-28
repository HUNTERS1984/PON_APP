//
//  ShopCountTableViewCell.swift
//  PonApp
//
//  Created by OSXVN on 9/28/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class ShopCountTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbImageView: CircleImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var shopCountLabel: UILabel!
    
    var couponType: CouponType! {
        didSet {
            self.setDataForCell(self.couponType)
        }
    }
    
    func setDataForCell(couponType: CouponType) {
        self.thumbImageView.af_setImageWithURL(NSURL(string: couponType.couponTypeIconUrl)!)
        self.titleLabel.text = couponType.couponTypeName
        if let _ = couponType.shopCount {
            self.shopCountLabel.text = "\(couponType.shopCount)"
        }
    }
}
