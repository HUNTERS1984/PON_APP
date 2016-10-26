//
//  ApiRequest.swift
//  PonApp
//
//  Created by HaoLe on 9/23/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

public struct ApiRequest {
    
    static func authorized(_ completion: @escaping (ApiCompletion)) {
        ApiManager.processRequest(Authorized, method: .GET, hasAuth: true, completion: completion)
    }
    
    static func signUp(_ userName: String, email: String, password: String, completion: @escaping (ApiCompletion) ) {
        let parameters: [String: String?] = [
            "username": userName,
            "email": email ,
            "password": password
        ]
        ApiManager.processRequest(SignUp, method: .POST, parameters: parameters, completion: completion)
    }
    
    static func signIn(_ userName: String, password: String, completion: @escaping (ApiCompletion)) {
        let parameters: [String: String?] = [
            "username": userName,
            "password": password,
            "grant_type": password,
            "client_id": ClientId,
            "client_secret":ClientSecret
        ]
        ApiManager.processRequest(SignIn, method: .POST, parameters: parameters, completion: completion)
    }
    
    static func signOut(_ completion: @escaping (ApiCompletion)) {
        ApiManager.processRequest(SignOut, method: .GET, hasAuth: true, completion: completion)
    }
    
    static func getCouponByFeature(_ couponFeature: CouponFeature, hasAuth: Bool, longitude: Double? = nil, lattitude: Double? = nil, pageSize:Int = DefaultPageSize, pageIndex: Int, completion: @escaping (ApiCompletion)) {
        let endpoint = String(format:CouponByFeature, couponFeature.rawValue)
        var parameters: [String: String?] = [
            "page_size": "\(pageSize)",
            "page_index": "\(pageIndex)"
        ]
        if let _ = longitude, let _ = lattitude {
            parameters["longitude"] = "\(longitude)"
            parameters["latitude"] = "\(lattitude)"
        }
        ApiManager.processRequest(endpoint, method: .GET, parameters: parameters, hasAuth: hasAuth, completion: completion)
    }
    
    static func getFavoriteCoupon(_ pageSize:Int = DefaultPageSize, pageIndex: Int, completion: @escaping (ApiCompletion)) {
        let parameters: [String: String?] = [
            "page_size": "\(pageSize)",
            "page_index": "\(pageIndex)"
        ]
        ApiManager.processRequest(FavoriteCoupon, method: .GET, parameters: parameters, hasAuth: true, completion: completion)
    }
    
    static func getCouponDetail(_ couponId: Float, hasAuth: Bool, completion: @escaping (ApiCompletion)) {
        let endpoint = String(format:CouponDetail, Int(couponId))
        ApiManager.processRequest(endpoint, method: .GET, hasAuth: hasAuth, completion: completion)
    }
    
    static func getFollowedShop(_ pageSize:Int = DefaultPageSize, pageIndex: Int, completion: @escaping (ApiCompletion)) {
        let parameters: [String: String?] = [
            "page_size": "\(pageSize)",
            "page_index": "\(pageIndex)"
        ]
        ApiManager.processRequest(FollowedShop, method: .GET, parameters: parameters, hasAuth: true, completion: completion)
    }
    
    static func getShopDetail(_ shopId: Float, completion: @escaping (ApiCompletion)) {
        let endpoint = String(format:ShopDetail, shopId)
        ApiManager.processRequest(endpoint, method: .GET, completion: completion)
    }
    
    
    static func getUsedCoupon(_ pageSize:Int = DefaultPageSize, pageIndex: Int, completion: @escaping (ApiCompletion)) {
        ApiManager.processRequest(GetUsedCoupon, method: .GET, hasAuth: true, completion: completion)
    }
    
    
    static func getUserProfile(_ completion: @escaping (ApiCompletion)) {
        ApiManager.processRequest(UserProfile, method: .GET, hasAuth: true, completion: completion)
    }
    
    static func updateUserProfile(_ name: String? = nil, gender: Int? = nil, address: String? = nil, avatar: UIImage? = nil, completion: @escaping (ApiCompletion)) {
        if let _ =  avatar {
            let avatarData = UIImagePNGRepresentation(avatar!)
            let avatarFile = ApiFileUpload(data: avatarData!, name: "avatar_url", fileName: "avatar_url")
            let parameters: [String: String?] = [
                "name": name,
                "gender": "\(gender!)",
                "address": address
            ]
            ApiManager.processRequest(UserProfile, method: .POST, parameters: parameters, uploadFiles: [avatarFile], hasAuth: true, completion: completion)
        }else {
            let parameters: [String: String?] = [
                "name": name,
                "gender": "\(gender!)",
                "address": address
            ]
            ApiManager.processRequest(UserProfile, method: .POST, parameters: parameters, hasAuth: true, completion: completion)
        }
    }
    
    static func getCouponCategory(_ pageSize:Int = DefaultPageSize, pageIndex: Int, completion: @escaping (ApiCompletion)) {
        let parameters: [String: String?] = [
            "page_size": "\(pageSize)",
            "page_index": "\(pageIndex)"
        ]
        ApiManager.processRequest(GetCouponCategory, method: .GET, parameters: parameters, completion: completion)
    }
    
    static func getNumberOfShopByCategory(_ pageSize:Int = DefaultPageSize, pageIndex: Int, completion:  @escaping (ApiCompletion)) {
        let parameters: [String: String?] = [
            "page_size": "\(pageSize)",
            "page_index": "\(pageIndex)"
        ]
        ApiManager.processRequest(GetNumberOfShopByCategory, method: .GET, parameters: parameters, completion: completion)
    }
    
    static func getCouponByFeatureAndType(_ feature: CouponFeature, category: Int, hasAuth: Bool, longitude: Double? = nil, lattitude: Double? = nil, pageSize:Int = DefaultPageSize, pageIndex: Int, completion: @escaping (ApiCompletion)) {
        var parameters: [String: String?] = [
            "page_size": "\(pageSize)",
            "page_index": "\(pageIndex)"
        ]
        if let _ = longitude, let _ = lattitude {
            parameters["longitude"] = "\(longitude)"
            parameters["latitude"] = "\(lattitude)"
        }
        let endpoint = String(format:GetCouponByFeatureAndCategory, feature.rawValue, category)
        ApiManager.processRequest(endpoint, method: .GET, parameters: parameters, hasAuth: hasAuth, completion: completion)
    }
    
    static func getShopByFeatureAndCategory(_ feature: CouponFeature, category: Int, longitude: Double? = nil, lattitude: Double? = nil, pageSize:Int = DefaultPageSize, pageIndex: Int, completion: @escaping (ApiCompletion)) {
        var parameters: [String: String?] = [
            "page_size": "\(pageSize)",
            "page_index": "\(pageIndex)"
        ]
        if let _ = longitude, let _ = lattitude {
            parameters["longitude"] = "\(longitude)"
            parameters["latitude"] = "\(lattitude)"
        }
        let endpoint = String(format:GetShopByFeatureAndCategory, feature.rawValue, category)
        ApiManager.processRequest(endpoint, method: .GET, parameters: parameters, completion: completion)
    }
    
    static func getShopByFeature(_ feature: CouponFeature, longitude: Double? = nil, lattitude: Double? = nil, pageSize:Int = DefaultPageSize, pageIndex: Int, completion: @escaping (ApiCompletion)) {
        var parameters: [String: String?] = [
            "page_size": "\(pageSize)",
            "page_index": "\(pageIndex)"
        ]
        if let _ = longitude, let _ = lattitude {
            parameters["longitude"] = "\(longitude)"
            parameters["latitude"] = "\(lattitude)"
        }
        let endpoint = String(format:GetShopByFeature, feature.rawValue)
        ApiManager.processRequest(endpoint, method: .GET, parameters: parameters, completion: completion)
    }
    
    static func getShopByLattitudeAndLongitude(_ lattitude: Double, longitude: Double, pageSize:Int = DefaultPageSize, pageIndex: Int, completion: @escaping (ApiCompletion)) {
        let parameters: [String: String?] = [
            "page_size": "\(pageSize)",
            "page_index": "\(pageIndex)"
        ]
        let endpoint = String(format:GetShopByLattitudeAndLongitude, lattitude, longitude)
        ApiManager.processRequest(endpoint, method: .GET, parameters: parameters, completion: completion)
    }
    
    static func likeCoupon(_ couponId: Float, completion: @escaping (ApiCompletion)) {
        let parameters: [String: String?] = [
            "id": "\(Int(couponId))",
        ]
        let endpoint = String(format:LikeCoupon, Int(couponId))
        ApiManager.processRequest(endpoint, method: .POST, parameters: parameters, hasAuth: true, completion: completion)
    }
    
    static func followShop(_ shopId: Float, completion: @escaping (ApiCompletion)) {
        let parameters: [String: String?] = [
            "id": "\(Int(shopId))"
        ]
        let endpoint = String(format:LikeCoupon, Int(shopId))
        ApiManager.processRequest(endpoint, method: .POST, parameters: parameters, hasAuth: true, completion: completion)
    }
    
    static func signInFacebook(_ accessToken: String, completion: @escaping(ApiCompletion)) {
        let parameters: [String: String?] = [
            "facebook_access_token": accessToken
        ]
        ApiManager.processRequest(SignInFacebook, method: .POST, parameters: parameters, completion: completion)
    }
    
    static func signInTwitter(_ token: String, tokenSecret: String, completion: @escaping(ApiCompletion)) {
        let parameters: [String: String?] = [
            "twitter_access_token": token,
            "twitter_access_token_secret": tokenSecret
        ]
        ApiManager.processRequest(SignInTwitter, method: .POST, parameters: parameters, completion: completion)
    }

}
