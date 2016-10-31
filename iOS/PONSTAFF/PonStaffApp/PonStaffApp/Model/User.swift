//
//  User.swift
//  PonStaffApp
//
//  Created by HaoLe on 10/31/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

struct User {
    
    var userName: String!
    
    init(response: JSON?) {
        if let userName = response!["username"].string {
            self.userName = userName
        }
    }
}
