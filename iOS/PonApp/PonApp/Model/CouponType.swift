//
//  CouponType.swift
//  PonApp
//
//  Created by OSXVN on 9/28/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit
import SwiftyJSON

struct CouponType {
    
    var couponTypeID: Int!
    var couponTypeName: String!
    var couponTypeIconUrl: String!
    var shopCount: Int!
    
    init(response: JSON?) {
        if let couponTypeID = response!["id"].int {
            self.couponTypeID = couponTypeID
        }else {
            if let couponTypeID = response!["id"].string {
                self.couponTypeID = couponTypeID.integerValue
            }
        }
        
        if let couponTypeName = response!["name"].string {
            self.couponTypeName = couponTypeName
        }
        
        if let couponTypeIconUrl = response!["icon_url"].string {
            self.couponTypeIconUrl = couponTypeIconUrl
        }
        
        if let shopCount = response!["shop_count"].int {
            self.shopCount = shopCount
        }
    }
}
