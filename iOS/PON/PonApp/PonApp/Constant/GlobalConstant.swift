//
//  GlobalConstant.swift
//  benhvien-phongkham
//
//  Created by HaoLe on 12/30/15.
//  Copyright © 2015 HaoLe. All rights reserved.
//

import UIKit

let DefaultBackgroundColor                      = 0xF8F8FA
let DefaultBorderColor                          = 0xc8d2d6
let DefaultBlackTextColor                       = 0x505a5e
let DefaultLightGrayTextColor                   = 0x82898b
let DefaultDarkGrayTextColor                    = 0x646e72
let DefaultPinkTextColor                        = 0xff5078
let DefaultBlueTextColor                        = 0x18c0d4
let DefaultPlaceHolderColor                     = 0xd2dade
let DefaultDarkTextColor                        = 0x626D71

//let GoogleMapAPIKey                             = "AIzaSyBPVkG6R4eBAD7XJV09z7ig3QC0zU8D2ns"
let GoogleMapAPIKey                             = "AIzaSyCWPCOVykZmln4xRd94C7-GeTLpGFGsMvU"//Test

let TWConsumerKey                               = "002neLhPbyLMt6rBP68wVVstN"
let TWConsumerSecret                            = "u2Cp1LFDin1zeQXxqXdgQEddZP06wsEPMxotStnThe7OsBVK43"

let ClientId                                    = "1_3bcbxd9e24g0gk4swg0kwgcwg4o8k8g4g888kwc44gcc0gwwk4"
let ClientSecret                                = "4ok2x70rlfokc8g0wws8c8kwcokw80k44sg48goc0ok4w0so0k"

let FacebookAppID                               = "324209427951910"
let OneSignalAppID                              = "42110bfd-23fb-4e29-bd2a-549778e069d6"
let OneSignalAppKey                             = "NjFjMWJhYTYtMjBlZi00OTU4LWFhZTctZTM4MWQyNmU2ODVl"

let DefaultPageSize                             = 10

public enum GetType {
    case reload
    case loadMore
    case new
}

public enum LoginState {
    case normal
    case qick
}

public enum CouponFeature: Int {
    case popularity = 1
    case new = 2
    case near = 3
    case deal = 4
}

//MARK: - Notification

let TokenInvalidNotification                    = "TokenInvalidNotification"
let NewCouponPushNotification                   = "NewCouponPushNotification"
let LikeCouponNotification                      = "LikeCouponNotification"

//<string name="sns_connect">連携</string>
//<string name="sns_disconnect">非接続</string>

//public static final String INSTAGRAM_CLIENT_ID = "cd9f614f85f44238ace18045a51c44d1";
//public static final String INSTAGRAM_CLIENT_SECRET = "d839149848c04447bd379ce8bff4d890";
//public static final String INSTAGRAM_CALLBACK_URL = "https://mytenant.auth0.com/login/callback";

//private static final String TWITTER_KEY = "002neLhPbyLMt6rBP68wVVstN";
//private static final String TWITTER_SECRET = "u2Cp1LFDin1zeQXxqXdgQEddZP06wsEPMxotStnThe7OsBVK43";
