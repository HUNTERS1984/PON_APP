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
    case popularity = 1
    case new = 2
    case near = 3
    case deal = 4
}

let Authorized                                  = "/v1/authorized"
let SignUp                                      = "/v1/signup"
let SignIn                                      = "/v1/signin"
let SignOut                                     = "/v1/signout"
let GetCouponCategory                           = "/v1/categories"
let CouponByFeature                             = "/v1/featured/%d/coupons"
let FavoriteCoupon                              = "/v1/favorite/coupons"
let CouponDetail                                = "/v1/coupons/%f"
let FollowedShop                                = "/v1/follow/shops"
let ShopDetail                                  = "/v1/shops/%f"
let GetUsedCoupon                               = "/v1/used/coupons"
let UserProfile                                 = "/v1/profile"
let GetNumberOfShopByCategory                   = "/v1/categories/shop"
let GetCouponByFeatureAndType                   = "/v1/featured/%d/coupons/%d"
let GetShopByFeatureAndCategory                 = "/v1/featured/%d/shops/%d"
let GetShopByFeature                            = "/v1/featured/%d/shops"
let GetShopByLattitudeAndLongitude              = "/v1/map/%f/%f/shops"
let LikeCoupon                                  = "/v1/like/coupons/1"
