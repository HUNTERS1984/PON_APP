//
//  ApiEndpoint.swift
//  PonApp
//
//  Created by HaoLe on 9/22/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

let SuccessCode                                 = 1000

let BaseURL                                     = "http://pon.cm/api"

let Authorized                                  = "/v1/authorized"
let SignInFacebook                              = "/v1/facebook/signin"
let SignInTwitter                               = "/v1/twitter/signin"
let SignIn                                      = "/v1/signin"
let SignInInstagram                             = "/v1/instagram/signin"
let SignOut                                     = "/v1/signout"
let SignUp                                      = "/v1/signup"
let GetCouponCategory                           = "/v1/categories"
let CouponByFeature                             = "/v1/featured/%d/coupons"
let FavoriteCoupon                              = "/v1/favorite/coupons"
let CouponDetail                                = "/v1/coupons/%d"
let FollowedShop                                = "/v1/follow/shops"
let ShopDetail                                  = "/v1/shops/%d"
let GetUsedCoupon                               = "/v1/used/coupons"
let UserProfile                                 = "/v1/profile"
let GetNumberOfShopByCategory                   = "/v1/categories/shop"
let GetCouponByFeatureAndCategory               = "/v1/featured/%d/category/%d/coupons"
let GetShopByFeatureAndCategory                 = "/v1/featured/%d/shops/%d"
let GetShopByFeature                            = "/v1/featured/%d/shops"
let GetShopByLattitudeAndLongitude              = "/v1/map/%f/%f/shops"
let LikeCoupon                                  = "/v1/like/coupons/%d"
let FollowShop                                  = "/v1/follow/shops/%d"
let RequestUseCoupon                            = "/v1/request/coupons/"
let GetNews                                     = "/v1/news"
let GetNewsDetails                              = "/v1/news/%d"
let UpdateFacebookToken                         = "/v1/facebook/token"
let UpdateTwitterToken                          = "/v1/twitter/token"
let UpdateTokenInstagram                        = "/v1/instagram/token"
let UnLikeCoupon                                = "/v1/unlike/coupons/%d"
let UnFollowShop                                = "/v1/unfollow/shops/%d"
let SearchCoupon                                = "/v1/search/coupons"
let ChangePass                                  = "/v1/password"
let ForgotPassword                              = "/v1/forgot/password"
