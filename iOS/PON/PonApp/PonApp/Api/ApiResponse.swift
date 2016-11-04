//
//  ApiResponse.swift
//  PonApp
//
//  Created by HaoLe on 9/21/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

struct ApiResponse {
    
    var message: String = ""
    var data:JSON?
    var code: Int!
    var originalResponse: JSON!
    
    var totalPage: Int!
    var currentPage: Int!
    var nextPage: Int!
    
    init(message: String, data: JSON?, code: Int) {
        self.message = message
        self.data = data
        self.code = code
    }
    
    init(response: JSON?) {
        if let message = response!["message"].string {
            self.message = message
        }else {
            self.message = ""
        }
        
        if let data = response!["data"].dictionary {
            self.data = JSON(data)
        }
        
        if let data = response!["data"].array {
            self.data = JSON(data)
        }
        
        if let code = response!["code"].int {
            self.code = code

        }
        
        if let totalPage = response!["pagination"]["page_total"].int {
            self.totalPage = totalPage
        }else {
            self.totalPage = 0
        }
        
        if let currentPage = response!["pagination"]["current_page"].int {
            self.currentPage = currentPage
        }else {
            self.currentPage = 0
        }
        
        if let nextPage = response!["pagination"]["next_page"].int {
            self.nextPage = nextPage
        }else {
            self.nextPage = 0
        }
        
        self.originalResponse = response
    }
    
}
