//
//  UserDataManager.swift
//  PonApp
//
//  Created by HaoLe on 9/28/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class UserDataManager {
    
    class var shared: UserDataManager {
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
    var avatarImage: UIImage?
    var loggedIn: Bool = false
    var isSocialLogin: Bool = false
    var gender: Int?
    var usedCouponNumber: Int = 0
    var newsNumber: Int = 0
    var shopFollowNumber: Int = 0
    
    fileprivate func getUserProfile() {
        ApiRequest.getUserProfile { (request: URLRequest?, result: ApiResponse?, error: NSError?) in
            if let _ = error {
                
            }else {
                if result?.code == SuccessCode {
                    self.setUserData(result?.data)
                }
            }
        }
    }
    
    func setUserData(_ data: JSON?) {
        if let username = data!["username"].string {
            self.username = username
        }
        
        if let name = data!["name"].string {
            self.name = name
        }
        
        if let email = data!["email"].string {
            self.email = email
        }
        
        if let address = data!["address"].string {
            self.address = address
        }
        
        if let avatarUrl = data!["avatar_url"].string {
            self.avatarUrl = avatarUrl
        }
        
        if let gender = data!["gender"].int {
            self.gender = gender
        }
        
        if let usedCouponNumber = data!["used_number"].int {
            self.usedCouponNumber = usedCouponNumber
        }
        
        if let newsNumber = data!["news_number"].int {
            self.newsNumber = newsNumber
        }
        
        if let shopFollowNumber = data!["follow_number"].int {
            self.shopFollowNumber = shopFollowNumber
        }
    }
    
    func getAvatarImage() -> UIImage? {
        return self.avatarImage
    }
    
    //MARK: - Static Method
    
    static func getUserProfile() {
        delay(by: .seconds(1)){
            UserDataManager.shared.getUserProfile()
        }
    }
    
    static func isLoggedIn() -> Bool {
        return UserDataManager.shared.loggedIn
    }
    
    static func setUserData(_ data: JSON?) {
        return UserDataManager.shared.setUserData(data)
    }
    
    static func getAvatarImage() -> UIImage? {
        return UserDataManager.shared.getAvatarImage()
    }
    
    static func clearUserData() {
        UserDataManager.shared.username = nil
        UserDataManager.shared.name = nil
        UserDataManager.shared.email = nil
        UserDataManager.shared.address = nil
        UserDataManager.shared.avatarUrl = nil
        UserDataManager.shared.avatarImage = nil
        UserDataManager.shared.loggedIn = false
        UserDataManager.shared.gender = nil
        UserDataManager.shared.usedCouponNumber = 0
        UserDataManager.shared.newsNumber = 0
        UserDataManager.shared.shopFollowNumber = 0
    }
    
}
