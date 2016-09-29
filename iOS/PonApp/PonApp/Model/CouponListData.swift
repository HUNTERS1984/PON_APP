//
//  CouponListData.swift
//  PonApp
//
//  Created by HaoLe on 9/27/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit
import SwiftyJSON

struct CouponListData {
    var couponTypeId: Float!
    var couponTypeIconUrl: String!
    var couponType: String!
    var coupons = [Coupon]()
    
    
    init(response: JSON?) {
        if let couponTypeId = response!["id"].float {
            self.couponTypeId = couponTypeId
        }else {
            if let couponTypeId = response!["id"].string {
                self.couponTypeId = couponTypeId.floatValue
            }
        }
        
        if let couponTypeIconUrl = response!["icon_url"].string {
            self.couponTypeIconUrl = couponTypeIconUrl
        }else {
            self.couponTypeIconUrl = ""
        }
        
        if let couponType = response!["name"].string {
            self.couponType = couponType
        }else {
            self.couponType = ""
        }
        
        if let couponsArray = response!["coupons"].array {
            for couponData in couponsArray {
                var coupon = Coupon(response: couponData)
                coupon.couponType = couponType
                self.coupons.append(coupon)
            }
        }
    }
    
}
