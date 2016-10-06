//
//  Category.swift
//  PonApp
//
//  Created by OSXVN on 10/2/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

struct Category {
    
    var categoryID: Int!
    var categoryName: String!
    var categoryIconUrl: String!
    var shopCount: Int!
    
    init(response: JSON?) {
        if let categoryID = response!["id"].int {
            self.categoryID = categoryID
        }else {
            if let categoryID = response!["id"].string {
                self.categoryID = categoryID.integerValue
            }
        }
        
        if let categoryName = response!["name"].string {
            self.categoryName = categoryName
        }
        
        if let categoryIconUrl = response!["icon_url"].string {
            self.categoryIconUrl = categoryIconUrl
        }
        
        if let shopCount = response!["shop_count"].int {
            self.shopCount = shopCount
        }else {
            self.shopCount = 0
        }
    }
}

