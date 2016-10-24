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
        self.originalResponse = response
    }
    
}
