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
            parameters["longitude"] = "\(longitude!)"
            parameters["latitude"] = "\(lattitude!)"
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
        let endpoint = String(format:ShopDetail, Int(shopId))
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
            parameters["longitude"] = "\(longitude!)"
            parameters["latitude"] = "\(lattitude!)"
        }
        let endpoint = String(format:GetCouponByFeatureAndCategory, feature.rawValue, category)
        ApiManager.processRequest(endpoint, method: .GET, parameters: parameters, hasAuth: hasAuth, completion: completion)
    }
    
    static func getShopByFeatureAndCategory(_ feature: CouponFeature, category: Int, hasAuth: Bool, longitude: Double? = nil, lattitude: Double? = nil, pageSize:Int = DefaultPageSize, pageIndex: Int, completion: @escaping (ApiCompletion)) {
        var parameters: [String: String?] = [
            "page_size": "\(pageSize)",
            "page_index": "\(pageIndex)"
        ]
        if let _ = longitude, let _ = lattitude {
            parameters["longitude"] = "\(longitude!)"
            parameters["latitude"] = "\(lattitude!)"
        }
        let endpoint = String(format:GetShopByFeatureAndCategory, feature.rawValue, category)
        ApiManager.processRequest(endpoint, method: .GET, parameters: parameters, hasAuth: hasAuth, completion: completion)
    }
    
    static func getShopByFeature(_ feature: CouponFeature, longitude: Double? = nil, lattitude: Double? = nil, hasAuth: Bool, pageSize:Int = DefaultPageSize, pageIndex: Int, completion: @escaping (ApiCompletion)) {
        var parameters: [String: String?] = [
            "page_size": "\(pageSize)",
            "page_index": "\(pageIndex)"
        ]
        if let _ = longitude, let _ = lattitude {
            parameters["longitude"] = "\(longitude!)"
            parameters["latitude"] = "\(lattitude!)"
        }
        let endpoint = String(format:GetShopByFeature, feature.rawValue)
        ApiManager.processRequest(endpoint, method: .GET, parameters: parameters, hasAuth:hasAuth, completion: completion)
    }
    
    static func getShopByLattitudeAndLongitude(_ lattitude: Double, longitude: Double, hasAuth: Bool, pageSize:Int = DefaultPageSize, pageIndex: Int, completion: @escaping (ApiCompletion)) {
        let parameters: [String: String?] = [
            "page_size": "\(pageSize)",
            "page_index": "\(pageIndex)"
        ]
        let endpoint = String(format:GetShopByLattitudeAndLongitude, lattitude, longitude)
        ApiManager.processRequest(endpoint, method: .GET, parameters: parameters, hasAuth: hasAuth, completion: completion)
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
        let endpoint = String(format:FollowShop, Int(shopId))
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
    
    static func requestUseCoupon(_ code: String, completion: @escaping(ApiCompletion)) {
        let parameters: [String: String?] = [
            "code": "\(code)"
        ]
        let endpoint = RequestUseCoupon + "\(code)"
        ApiManager.processRequest(endpoint, method: .POST, parameters: parameters, hasAuth: true, completion: completion)
    }
    
    static func getNews(_ pageSize:Int = DefaultPageSize, pageIndex: Int, completion: @escaping (ApiCompletion)) {
        let parameters: [String: String?] = [
            "page_size": "\(pageSize)",
            "page_index": "\(pageIndex)"
        ]
        ApiManager.processRequest(GetNews, method: .GET, parameters: parameters, hasAuth:true, completion: completion)
    }
    
    static func getNewsDetails(_ newsId: Float, completion: @escaping (ApiCompletion)) {
        let endpoint = String(format:GetNewsDetails, Int(newsId))
        ApiManager.processRequest(endpoint, method: .GET, hasAuth:true, completion: completion)
    }
    
    static func updateFacebookAccessToken(_ accessToken: String, completion: @escaping (ApiCompletion)) {
        let parameters: [String: String?] = [
            "facebook_access_token": accessToken
        ]
        ApiManager.processRequest(UpdateFacebookToken, method: .POST, parameters: parameters, hasAuth: true, completion: completion)
    }
    
    static func updateTwitterToken(_ accessToken: String, accessTokenSecret: String, completion: @escaping (ApiCompletion)) {
        let parameters: [String: String?] = [
            "twitter_access_token": accessToken,
            "twitter_access_token_secret": accessTokenSecret
        ]
        ApiManager.processRequest(UpdateTwitterToken, method: .POST, parameters: parameters, hasAuth: true, completion: completion)
    }
    
    static func signInInstagram(_ accessToken: String, completion: @escaping(ApiCompletion)) {
        let parameters: [String: String?] = [
            "instagram_access_token": accessToken
        ]
        ApiManager.processRequest(SignInInstagram, method: .POST, parameters: parameters, completion: completion)
    }
    
    static func updateInstagramAccessToken(_ accessToken: String, completion: @escaping (ApiCompletion)) {
        let parameters: [String: String?] = [
            "instagram_access_token": accessToken
        ]
        ApiManager.processRequest(UpdateTokenInstagram, method: .POST, parameters: parameters, hasAuth: true, completion: completion)
    }
    
    static func unLikeCoupon(_ couponId: Float, completion: @escaping (ApiCompletion)) {        
        let parameters: [String: String?] = [
            "id": "\(Int(couponId))",
        ]
        let endpoint = String(format:UnLikeCoupon, Int(couponId))
        ApiManager.processRequest(endpoint, method: .POST, parameters: parameters, hasAuth: true, completion: completion)
    }
    
    static func unFollowShop(_ shopId: Float, completion: @escaping (ApiCompletion)) {
        let parameters: [String: String?] = [
            "id": "\(Int(shopId))"
        ]
        let endpoint = String(format:UnFollowShop, Int(shopId))
        ApiManager.processRequest(endpoint, method: .POST, parameters: parameters, hasAuth:true, completion: completion)
    }
    
    static func searchCoupon(_ searchText: String, pageSize:Int = DefaultPageSize, pageIndex: Int, hasAuth: Bool, completion: @escaping (ApiCompletion)) {
        let parameters: [String: String?] = [
            "query": "\(searchText)",
            "page_size": "\(pageSize)",
            "page_index": "\(pageIndex)"
        ]
        ApiManager.processRequest(SearchCoupon, method: .GET, parameters: parameters, hasAuth: hasAuth, completion: completion)
    }
    
    static func changePassword(_ oldPass: String, newPass: String , confirmPass: String, completion: @escaping (ApiCompletion)) {
        let parameters: [String: String?] = [
            "old_password": "\(oldPass)",
            "new_password": "\(newPass)",
            "confirm_password": "\(confirmPass)"
        ]
        ApiManager.processRequest(ChangePass, method: .PUT, parameters: parameters, hasAuth: true, completion: completion)
    }
    
    static func forgotPassword(_ email: String, completion: @escaping (ApiCompletion)) {
        let parameters: [String: String?] = [
            "email": email
        ]
        ApiManager.processRequest(ForgotPassword, method: .POST, parameters: parameters, hasAuth: false, completion: completion)
    }
    
    static func getSettingUrl(_ type: String, completion: @escaping (ApiCompletion)) {
        //contact, term, privacy, trade
        let url = SettingUrl + type
        ApiManager.processRequest(url, method: .GET, hasAuth: false, completion: completion)
    }
}
