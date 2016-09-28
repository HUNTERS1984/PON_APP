//
//  CouponTypeTableViewCell.swift
//  PonApp
//
//  Created by OSXVN on 9/28/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class CouponTypeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbImageView: CircleImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var couponType: CouponType! {
        didSet {
            self.setDataForCell(self.couponType)
        }
    }
    
    func setDataForCell(couponType: CouponType) {
        self.thumbImageView.af_setImageWithURL(NSURL(string: couponType.couponTypeIconUrl)!)
        self.titleLabel.text = couponType.couponTypeName
    }
}
