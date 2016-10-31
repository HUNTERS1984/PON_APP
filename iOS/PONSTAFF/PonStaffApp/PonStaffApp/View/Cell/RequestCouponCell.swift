//
//  RequestCouponCell.swift
//  PonStaffApp
//
//  Created by HaoLe on 10/25/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class RequestCouponCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var coupon: Coupon! {
        didSet {
            self.setDataForCell(self.coupon)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDataForCell(_ coupon: Coupon) {
        self.titleLabel.text = coupon.user.userName
        self.detailsLabel.text = coupon.title
        self.timeLabel.text = coupon.expiryDate
    }

}
