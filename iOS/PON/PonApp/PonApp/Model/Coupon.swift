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
    var canUse: Bool!
    var isLike: Bool!
    var needLogin: Bool!
    var isUsed: Bool = false
    var description: String!
    var shopAddress: String!
    var shopPhonenumber: String!
    var shopCloseDate: String!
    var shopLongitude: Float!
    var shopLatitude: Float!
    var shopAvatarUrl: String!
    var shopStartTime: String!
    var shopEndTime: String!
    var couponType: String!
    var couponTypeIconUrl: String!
    var userPhotosUrl = [String]()
    var couponPhotosUrl = [String]()
    var similarCoupons = [Coupon]()
    var category: String!
    var categoryIcon: String!
    var code: String!
    var maskCouponId: String!
    var link: String?
    var twitterSharing: String?
    var twitterHashtag: String?
    var instagramSharing: String?
    var instagramHashtag: String?
    var lineSharing: String?
    var lineHashTag: String?
    
    var shopCoordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: Double(shopLatitude), longitude: Double(shopLongitude))
    }
    
    var showConfirmView: Bool = false
    
    init() {
    }
    
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
        
        if let needLogin = response!["need_login"].bool {
            self.needLogin = needLogin
        }else {
            self.needLogin = false
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
        
        if let shopCloseDate = response!["shop"]["close_date"].string {
            self.shopCloseDate = shopCloseDate
        }else {
            self.shopCloseDate = ""
        }
        
        if let shopLongitude = response!["shop"]["longitude"].float {
            self.shopLongitude = shopLongitude
        }else {
            if let shopLongitude = response!["shop"]["longitude"].string {
                self.shopLongitude = shopLongitude.floatValue
            }
        }
        
        if let shopLatitude = response!["shop"]["latitude"].float {
            self.shopLatitude = shopLatitude
        }else {
            if let shopLatitude = response!["shop"]["latitude"].string {
                self.shopLatitude = shopLatitude.floatValue
            }
        }
        
        if let shopAvatarUrl = response!["shop"]["avatar_url"].string {
            self.shopAvatarUrl = shopAvatarUrl
        }
        
        if let shopStartTime = response!["shop"]["operation_start_time"].string {
            self.shopStartTime = shopStartTime
        }
        
        if let shopEndTime = response!["shop"]["operation_end_time"].string {
            self.shopEndTime = shopEndTime
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
        
        if let similarCoupons = response!["similar_coupons"].array {
            for couponData in similarCoupons {
                var coupon = Coupon(response: couponData)
                coupon.couponType = self.couponType
                self.similarCoupons.append(coupon)
            }
        }
        
        if let code = response!["code"].string {
            self.code = code
        }
        
        if let category = response!["shop"]["category"]["name"].string {
            self.category = category
        }
        
        if let categoryIcon = response!["shop"]["category"]["icon_url"].string {
            self.categoryIcon = categoryIcon
        }
        
        if let maskCouponId = response!["coupon_id"].string {
            self.maskCouponId = maskCouponId
        }else {
            self.maskCouponId = ""
        }
        
        if let link = response!["link"].string {
            self.link = link
        }
        
        
        if let twitterSharing = response!["twitter_sharing"].string {
            let data: [String] = twitterSharing.components(separatedBy: "\n")
            self.twitterSharing = data[1].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }else {
            self.twitterSharing = ""
        }
        
        if let instagramSharing = response!["instagram_sharing"].string {
            self.instagramSharing = instagramSharing
        }else {
            self.instagramSharing = ""
        }
        
        if let lineSharing = response!["line_sharing"].string {
            let data: [String] = lineSharing.components(separatedBy: "\n")
            self.lineHashTag = data[0].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            self.lineSharing = data[1].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }else {
            self.lineSharing = ""
        }
    }
    
}
