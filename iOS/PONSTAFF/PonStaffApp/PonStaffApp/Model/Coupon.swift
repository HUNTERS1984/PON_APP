//
//  Coupon.swift
//  PonApp
//
//  Created by HaoLe on 9/7/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

struct Coupon {
    var title: String!
    var username: String!
    var userId: String!
    var code: String!
    var time: String = ""
    
    init(response: JSON?) {
        
        if let title = response!["coupon"]["title"].string {
            self.title = title
        }
        
        if let username = response!["user"]["name"].string {
            self.username = username
        }
        
        if let userId = response!["user"]["username"].string {
            self.userId = userId
        }
        
        if let code = response!["code"].string {
            self.code = code;
        }
    }
    
}
