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
let DefaultBlackTextColor                       = 0x2e3038
let DefaultDarkTextColor                        = 0x626D71
let DefaultGreenTextColor                       = 0x14c8c8

let BaseURL                                     = "http://pon.cm/api"

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

let TokenInvalidNotification                    = "TokenInvalidNotification"
