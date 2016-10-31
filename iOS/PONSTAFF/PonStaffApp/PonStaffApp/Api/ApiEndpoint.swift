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
let SignIn                                      = "/v1/signin"
let SignOut                                     = "/v1/signout"
let RequestCoupon                               = "/v1/request/coupons"
let UserProfile                                 = "/v1/profile"
let AcceptCoupon                                = "/v1/accept/coupons/%d/user/%@"
let RejectCoupon                                = "/v1/decline/coupons/%d/user/%@"
