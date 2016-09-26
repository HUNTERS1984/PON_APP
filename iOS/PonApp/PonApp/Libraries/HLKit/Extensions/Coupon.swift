//
//  Coupon.swift
//  PonApp
//
//  Created by HaoLe on 9/7/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit
import SwiftyJSON

struct Coupon {
    var couponID: Float!
    var imageURL: String!
    var title: String!
    var expiryDate: String!
    var canUse: Bool!
    var isLike: Bool!
    var description: String!
    var shopAddress: String!
    var shopPhonenumber: String!
    var shopBusinessHours: String!
    var shopLongitude: Float!
    var shopLatitude: Float!
    var shopAvatarUrl: String!
    var couponType: String!
    var couponTypeIconUrl: String!
    var userPhotosUrl = [String]()
    var couponPhotosUrl = [String]()
    
    var showConfirmView: Bool = false
    
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
        
        if let canUse = response!["can_use"].bool {
            self.canUse = canUse
        }else {
            self.canUse = false
        }
        
        if let isLike = response!["is_like"].bool {
            self.isLike = isLike
        }else {
            self.isLike = false
        }
        
        if let description = response!["description"].string {
            self.description = description
        }else {
            self.description = ""
        }
        
        if let shopAddress = response!["shop"]["address"].string {
            self.shopAddress = shopAddress
        }else {
            self.shopAddress = ""
        }
        
        if let shopPhonenumber = response!["shop"]["tel"].string {
            self.shopPhonenumber = shopPhonenumber
        }else {
            self.shopPhonenumber = ""
        }
        
        if let shopBusinessHours = response!["shop"]["close_date"].string {
            self.shopBusinessHours = shopBusinessHours
        }else {
            self.shopBusinessHours = ""
        }
        
        if let shopLongitude = response!["shop"]["longitude"].float {
            self.shopLongitude = shopLongitude
        }
        
        if let shopLatitude = response!["shop"]["lattitude"].float {
            self.shopLatitude = shopLatitude
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
        
        if let userPhoto = response!["user_photo_url"].array {
            for url in userPhoto {
                self.userPhotosUrl.append(url.stringValue)
            }
        }
        
        if let couponPhoto = response!["coupon_photo_url"].array {
            for url in couponPhoto {
                self.couponPhotosUrl.append(url.stringValue)
            }
        }
    }
    
}
