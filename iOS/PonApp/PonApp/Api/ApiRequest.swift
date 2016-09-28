//
//  ApiRequest.swift
//  PonApp
//
//  Created by HaoLe on 9/23/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

public struct ApiRequest {
    
    static func authorized(completion: ApiCompletion) {
        ApiManager.processRequest(Authorized, method: .GET, hasAuth: true, completion: completion)
    }
    
    static func signUp(userName: String, email: String, password: String, completion: ApiCompletion) {
        let parameters: [String: AnyObject?] = [
            "username": userName,
            "email": email,
            "password": password
        ]
        ApiManager.processRequest(SignUp, method: .POST, parameters: parameters, completion: completion)
    }
    
    static func signIn(userName: String, password: String, completion: ApiCompletion) {
        let parameters: [String: AnyObject?] = [
            "username": userName,
            "password": password,
            "grant_type": password,
            "client_id": ClientId,
            "client_secret":ClientSecret
        ]
        ApiManager.processRequest(SignIn, method: .POST, parameters: parameters, completion: completion)
    }
    
    static func signOut(completion: ApiCompletion) {
        ApiManager.processRequest(SignOut, method: .GET, hasAuth: true, completion: completion)
    }
    
    static func getCouponByFeature(couponFeature: CouponFeature, completion: ApiCompletion) {
        let endpoint = String(format:CouponByFeature, couponFeature.rawValue)
        ApiManager.processRequest(endpoint, method: .GET, completion: completion)
    }
    
    static func getFavoriteCoupon(pageSize:Int = DefaultPageSize, pageIndex: Int, completion: ApiCompletion) {
        let parameters: [String: AnyObject?] = [
            "page_size": pageSize,
            "page_index": pageIndex
        ]
        ApiManager.processRequest(FavoriteCoupon, method: .GET, parameters: parameters, hasAuth: true, completion: completion)
    }
    
    static func getCouponDetail(couponId: Float, completion: ApiCompletion) {
        let endpoint = String(format:CouponDetail, couponId)
        ApiManager.processRequest(endpoint, method: .GET, completion: completion)
    }
    
    static func getFollowedShop(pageSize:Int = DefaultPageSize, pageIndex: Int, completion: ApiCompletion) {
        let parameters: [String: AnyObject?] = [
            "page_size": pageSize,
            "page_index": pageIndex
        ]
        ApiManager.processRequest(FollowedShop, method: .GET, parameters: parameters, hasAuth: true, completion: completion)
    }
    
    static func getShopDetail(shopId: Float, completion: ApiCompletion) {
        let endpoint = String(format:ShopDetail, shopId)
        ApiManager.processRequest(endpoint, method: .GET, completion: completion)
    }
    
    
    static func getUsedCoupon(pageSize:Int = DefaultPageSize, pageIndex: Int, completion: ApiCompletion) {
        ApiManager.processRequest(GetUsedCoupon, method: .GET, hasAuth: true, completion: completion)
    }
    
    
    static func getUserProfile(completion: ApiCompletion) {
        ApiManager.processRequest(UserProfile, method: .GET, hasAuth: true, completion: completion)
    }
    
    static func updateUserProfile(name: String? = nil, gender: Int? = nil, address: String? = nil, avatar: UIImage? = nil, completion: ApiCompletion) {
        if let _ =  avatar {
            let avatarData = UIImagePNGRepresentation(avatar!)
            let avatarFile = ApiFileUpload(data: avatarData!, name: "avatar_url", fileName: "avatar_url")
            let parameters: [String: AnyObject?] = [
                "name": name,
                "gender": "\(gender!)",
                "address": address
            ]
            ApiManager.processRequest(UserProfile, method: .POST, parameters: parameters, uploadFiles: [avatarFile], hasAuth: true, completion: completion)
        }else {
            let parameters: [String: AnyObject?] = [
                "name": name,
                "gender": gender,
                "address": address
            ]
            ApiManager.processRequest(UserProfile, method: .POST, parameters: parameters, hasAuth: true, completion: completion)
        }
        
    }

}
