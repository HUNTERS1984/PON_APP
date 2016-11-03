//
//  Shop.swift
//  PonApp
//
//  Created by HaoLe on 9/27/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

struct Shop {
    
    var shopID: Float!
    var avatarUrl: String!
    var title: String!
    var shopLongitude: Float!
    var shopLatitude: Float!
    var shopAddress: String!
    var shopPhonenumber: String!
    var shopPhotosUrl = [String]()
    var coupons = [Coupon]()
    var shopAvegerBill: Float!
    var regularHoliday: String!
    var shopDirection: String!
    var shopStartTime: String!
    var shopEndTime: String!
    var isFollow: Bool!
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: Double(shopLatitude), longitude: Double(shopLongitude))
    }

    init(response: JSON?) {
        if let shopID = response!["id"].float {
            self.shopID = shopID
        }else {
            if let shopID = response!["id"].string {
                self.shopID = shopID.floatValue
            }
        }
        
        if let avatarUrl = response!["avatar_url"].string {
            self.avatarUrl = avatarUrl
        }else {
            self.avatarUrl = ""
        }
        
        if let title = response!["title"].string {
            self.title = title
        }else {
            self.title = ""
        }
        
        if let shopLongitude = response!["longitude"].float {
            self.shopLongitude = shopLongitude
        }else {
            if let shopLongitude = response!["longitude"].string {
                self.shopLongitude = shopLongitude.floatValue
            }
        }
        
        if let shopLatitude = response!["latitude"].float {
            self.shopLatitude = shopLatitude
        }else {
            if let shopLatitude = response!["latitude"].string {
                self.shopLatitude = shopLatitude.floatValue
            }
        }
        
        if let shopAddress = response!["address"].string {
            self.shopAddress = shopAddress
        }else {
            self.shopAddress = ""
        }
        
        if let shopPhonenumber = response!["tel"].string {
            self.shopPhonenumber = shopPhonenumber
        }else {
            self.shopPhonenumber = ""
        }
        
        if let couponPhoto = response!["shop_photo_url"].array {
            for url in couponPhoto {
                self.shopPhotosUrl.append(url.stringValue)
            }
        }
        
        if let similarCoupons = response!["coupons"].array {
            for couponData in similarCoupons {
                self.coupons.append(Coupon(response: couponData))
            }
        }
        
        if let shopAvegerBill = response!["ave_bill"].float {
            self.shopAvegerBill = shopAvegerBill
        }
        
        if let regularHoliday = response!["close_date"].string {
            self.regularHoliday = regularHoliday
        }
        
        if let shopDirection = response!["help_text"].string {
            self.shopDirection = shopDirection
        }
        
        if let shopStartTime = response!["operation_start_time"].string {
            self.shopStartTime = shopStartTime
        }
        
        if let shopEndTime = response!["operation_end_time"].string {
            self.shopEndTime = shopEndTime
        }
        
        if let isFollow = response!["is_follow"].bool {
            self.isFollow = isFollow
        }else {
            self.isFollow = false
        }
    }
    
}
