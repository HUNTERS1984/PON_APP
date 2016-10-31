//
//  Coupon.swift
//  PonApp
//
//  Created by HaoLe on 9/7/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

struct Coupon {
    var couponID: Float!
    var imageURL: String!
    var title: String!
    var expiryDate: String!
    var shopAvatarUrl: String!
    var couponType: String!
    var couponTypeIconUrl: String!
    var category: String!
    var categoryIcon: String!
    var user: User!
    
    init(response: JSON?) {
        if let couponID = response!["id"].float {
            self.couponID = couponID
        }else {
            if let couponID = response!["id"].string {
                self.couponID = couponID.floatValue
            }
        }
        
        if let imageUrl = response!["image_url"].string {
            self.imageURL = imageUrl
        }else {
            self.imageURL = ""
        }
        
        if let title = response!["title"].string {
            self.title = title
        }else {
            self.title = ""
        }
        
        if let expiryDate = response!["expired_time"].string {
            self.expiryDate = "期限 : \(String.convertDateFormater(expiryDate))"
        }
        
        if let shopAvatarUrl = response!["shop"]["avatar_url"].string {
            self.shopAvatarUrl = shopAvatarUrl
        }
        
        if let couponType = response!["coupon_type"]["name"].string {
            self.couponType = couponType
        }
        
        if let couponTypeIconUrl = response!["coupon_type"]["icon_url"].string {
            self.couponTypeIconUrl = couponTypeIconUrl
        }
        
        if let category = response!["shop"]["category"]["name"].string {
            self.category = category
        }
        
        if let categoryIcon = response!["shop"]["category"]["icon_url"].string {
            self.categoryIcon = categoryIcon;
        }
        
        if let users = response!["users"].array {
            self.user = User(response: users[0])
        }
    }
    
}
