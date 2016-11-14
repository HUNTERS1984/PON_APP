//
//  News.swift
//  PonApp
//
//  Created by HaoLe on 11/14/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

struct News {
    
    var newsID: Float!
    var title: String!
    var imageUrl: String!
    var introduction: String!
    
    init(response: JSON?) {
        if let newsID = response!["id"].float {
            self.newsID = newsID
        }else {
            if let newsID = response!["id"].string {
                self.newsID = newsID.floatValue
            }
        }
        
        if let title = response!["title"].string {
            self.title = title
        }else {
            self.title = ""
        }
        
        if let imageUrl = response!["image_url"].string {
            self.imageUrl = imageUrl
        }else {
            self.imageUrl = ""
        }
        
        if let introduction = response!["introduction"].string {
            self.introduction = introduction
        }else {
            self.introduction = ""
        }
    }

}
