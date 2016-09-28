//
//  ApiEndpoint.swift
//  PonApp
//
//  Created by HaoLe on 9/22/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

let SuccessCode                                 = 1000

public enum CouponFeature: Int {
    case Popularity = 1
    case NewArrival = 2
    case Near = 3
    case Deal = 4
}

let Authorized                                  = "/v1/authorized"
let SignUp                                      = "/v1/signup"
let SignIn                                      = "/v1/signin"
let SignOut                                     = "/v1/signout"
let GetCouponType                               = "/v1/coupon/types"
let CouponByFeature                             = "/v1/featured/%d/coupons"
let FavoriteCoupon                              = "/v1/favorite/coupons"
let CouponDetail                                = "/v1/coupons/%f"
let FollowedShop                                = "/v1/follow/shops"
let ShopDetail                                  = "/v1/shops/%f"
let GetUsedCoupon                               = "/v1/used/coupons"
let UserProfile                                 = "/v1/profile"
let GetNumberOfShopByType                       = "/v1/coupon/types/shop"
let GetCouponByFeatureAndType                   = "/v1/featured/%d/coupons/%d"
let GetShopByFeatureAndType                     = "/v1/featured/%d/shops/%d"