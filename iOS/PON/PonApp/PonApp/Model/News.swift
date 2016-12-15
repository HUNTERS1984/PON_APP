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
    var type: String!
    var imageUrl: String?
    var introduction: String!
    var description: String!
    var createdAt: String!
    var photosUrls = [String]()
    
    init(response: JSON?) {
        if let newsID = response!["id"].float {
            self.newsID = newsID
        }else {
            if let newsID = response!["id"].string {
                self.newsID = newsID.floatValue
            }
        }
        
        if let type = response!["category"]["name"].string {
            self.type = type
        }else {
            self.type = ""
        }
        
        if let title = response!["title"].string {
            self.title = title
        }else {
            self.title = ""
        }
        
        if let imageUrl = response!["image_url"].string {
            self.imageUrl = imageUrl
        }
        
        if let introduction = response!["introduction"].string {
            self.introduction = introduction
        }else {
            self.introduction = ""
        }
        
        if let description = response!["description"].string {
            self.description = description
        }else {
            self.description = ""
        }
        
        if let createdAt = response!["created_at"].string {
            self.createdAt = "\(String.convertDateFormater(createdAt))"
        }
        
        if let newsPhoto = response!["news_photo_url"].array {
            for url in newsPhoto {
                self.photosUrls.append(url.stringValue)
            }
        }
    }

}
