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
    var categoryId: Float!
    var categoryIconUrl: String!
    var categoryName: String!
    var coupons = [Coupon]()
    
    
    init(response: JSON?) {
        if let categoryId = response!["id"].float {
            self.categoryId = categoryId
        }else {
            if let categoryId = response!["id"].string {
                self.categoryId = categoryId.floatValue
            }
        }
        
        if let categoryIconUrl = response!["icon_url"].string {
            self.categoryIconUrl = categoryIconUrl
        }else {
            self.categoryIconUrl = ""
        }
        
        if let categoryName = response!["name"].string {
            self.categoryName = categoryName
        }else {
            self.categoryName = ""
        }
        
        if let couponsArray = response!["coupons"].array {
            for couponData in couponsArray {
                let coupon = Coupon(response: couponData)
                self.coupons.append(coupon)
            }
        }
    }
    
}
