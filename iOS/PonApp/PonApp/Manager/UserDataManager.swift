//
//  UserDataManager.swift
//  PonApp
//
//  Created by HaoLe on 9/28/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class UserDataManager {
    
    class var sharedInstance: UserDataManager {
        struct Static {
            static let instance = UserDataManager()
        }
        return Static.instance
    }
    
    var username: String?
    var name: String?
    var email: String?
    var address: String?
    var avatarUrl: String?
    var loggedIn: Bool = false
    var gender: Int?
    
    fileprivate func getUserProfile() {
        ApiRequest.getUserProfile { (request: URLRequest?, result: ApiResponse?, error: NSError?) in
            if let _ = error {
                
            }else {
                if result?.code == SuccessCode {
                    if let username = result?.data!["username"].string {
                        self.username = username
                    }
                    
                    if let name = result?.data!["name"].string {
                        self.name = name
                    }
                    
                    if let email = result?.data!["email"].string {
                        self.email = email
                    }
                    
                    if let address = result?.data!["address"].string {
                        self.address = address
                    }
                    
                    if let avatarUrl = result?.data!["avatar_url"].string {
                        self.avatarUrl = avatarUrl
                    }
                    
                    if let gender = result?.data!["gender"].int {
                        self.gender = gender
                    }
                }
            }
        }
    }
    
    static func getUserProfile() {
        UserDataManager.sharedInstance.getUserProfile()
    }
    
    static func isLoggedIn() -> Bool {
        return UserDataManager.sharedInstance.loggedIn
    }
    
}
