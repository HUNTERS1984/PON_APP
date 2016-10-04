//
//  ApiRequest.swift
//  PonApp
//
//  Created by HaoLe on 9/23/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

public struct ApiRequest {
    
    static func authorized(_ completion: @escaping ApiCompletion) {
        ApiManager.processRequest(Authorized, method: .GET, hasAuth: true, completion: completion)
    }
    
    static func signUp(_ userName: String, email: String, password: String, completion: @escaping ApiCompletion) {
        let parameters: [String: AnyObject?] = [
            "username": userName as Optional<AnyObject>,
            "email": email as Optional<AnyObject>,
            "password": password as Optional<AnyObject>
        ]
        ApiManager.processRequest(SignUp, method: .POST, parameters: parameters, completion: completion)
    }
    
    static func signIn(_ userName: String, password: String, completion: @escaping ApiCompletion) {
        let parameters: [String: AnyObject?] = [
            "username": userName as Optional<AnyObject>,
            "password": password as Optional<AnyObject>,
            "grant_type": password as Optional<AnyObject>,
            "client_id": ClientId as Optional<AnyObject>,
            "client_secret":ClientSecret as Optional<AnyObject>
        ]
        ApiManager.processRequest(SignIn, method: .POST, parameters: parameters, completion: completion)
    }
    
    static func signOut(_ completion: @escaping ApiCompletion) {
        ApiManager.processRequest(SignOut, method: .GET, hasAuth: true, completion: completion)
    }
    
    static func getCouponByFeature(_ couponFeature: CouponFeature, completion: @escaping ApiCompletion) {
        let endpoint = String(format:CouponByFeature, couponFeature.rawValue)
        ApiManager.processRequest(endpoint, method: .GET, completion: completion)
    }
    
    static func getFavoriteCoupon(_ pageSize:Int = DefaultPageSize, pageIndex: Int, completion: @escaping ApiCompletion) {
        let parameters: [String: AnyObject?] = [
            "page_size": pageSize as Optional<AnyObject>,
            "page_index": pageIndex as Optional<AnyObject>
        ]
        ApiManager.processRequest(FavoriteCoupon, method: .GET, parameters: parameters, hasAuth: true, completion: completion)
    }
    
    static func getCouponDetail(_ couponId: Float, completion: @escaping ApiCompletion) {
        let endpoint = String(format:CouponDetail, couponId)
        ApiManager.processRequest(endpoint, method: .GET, hasAuth: true, completion: completion)
    }
    
    static func getFollowedShop(_ pageSize:Int = DefaultPageSize, pageIndex: Int, completion: @escaping ApiCompletion) {
        let parameters: [String: AnyObject?] = [
            "page_size": pageSize as Optional<AnyObject>,
            "page_index": pageIndex as Optional<AnyObject>
        ]
        ApiManager.processRequest(FollowedShop, method: .GET, parameters: parameters, hasAuth: true, completion: completion)
    }
    
    static func getShopDetail(_ shopId: Float, completion: @escaping ApiCompletion) {
        let endpoint = String(format:ShopDetail, shopId)
        ApiManager.processRequest(endpoint, method: .GET, completion: completion)
    }
    
    
    static func getUsedCoupon(_ pageSize:Int = DefaultPageSize, pageIndex: Int, completion: @escaping ApiCompletion) {
        ApiManager.processRequest(GetUsedCoupon, method: .GET, hasAuth: true, completion: completion)
    }
    
    
    static func getUserProfile(_ completion: @escaping ApiCompletion) {
        ApiManager.processRequest(UserProfile, method: .GET, hasAuth: true, completion: completion)
    }
    
    static func updateUserProfile(_ name: String? = nil, gender: Int? = nil, address: String? = nil, avatar: UIImage? = nil, completion: @escaping ApiCompletion) {
        if let _ =  avatar {
            let avatarData = UIImagePNGRepresentation(avatar!)
            let avatarFile = ApiFileUpload(data: avatarData!, name: "avatar_url", fileName: "avatar_url")
            let parameters: [String: AnyObject?] = [
                "name": name as Optional<AnyObject>,
                "gender": "\(gender!)" as Optional<AnyObject>,
                "address": address as Optional<AnyObject>
            ]
            ApiManager.processRequest(UserProfile, method: .POST, parameters: parameters, uploadFiles: [avatarFile], hasAuth: true, completion: completion)
        }else {
            let parameters: [String: AnyObject?] = [
                "name": name as Optional<AnyObject>,
                "gender": gender as Optional<AnyObject>,
                "address": address as Optional<AnyObject>
            ]
            ApiManager.processRequest(UserProfile, method: .POST, parameters: parameters, hasAuth: true, completion: completion)
        }
    }
    
    static func getCouponCategory(_ pageSize:Int = DefaultPageSize, pageIndex: Int, completion: @escaping ApiCompletion) {
        let parameters: [String: AnyObject?] = [
            "page_size": pageSize as Optional<AnyObject>,
            "page_index": pageIndex as Optional<AnyObject>
        ]
        ApiManager.processRequest(GetCouponCategory, method: .GET, parameters: parameters, completion: completion)
    }
    
    static func getNumberOfShopByCategory(_ pageSize:Int = DefaultPageSize, pageIndex: Int, completion:  @escaping ApiCompletion) {
        let parameters: [String: AnyObject?] = [
            "page_size": pageSize as Optional<AnyObject>,
            "page_index": pageIndex as Optional<AnyObject>
        ]
        ApiManager.processRequest(GetNumberOfShopByCategory, method: .GET, parameters: parameters, completion: completion)
    }
    
    static func getCouponByFeatureAndType(_ feature: CouponFeature, couponType: Int, pageSize:Int = DefaultPageSize, pageIndex: Int, completion: @escaping ApiCompletion) {
        let parameters: [String: AnyObject?] = [
            "page_size": pageSize as Optional<AnyObject>,
            "page_index": pageIndex as Optional<AnyObject>
        ]
        let endpoint = String(format:GetCouponByFeatureAndType, feature.rawValue, couponType)
        ApiManager.processRequest(endpoint, method: .GET, parameters: parameters, completion: completion)
    }
    
    static func getShopByFeatureAndCategory(_ feature: CouponFeature, couponType: Int, pageSize:Int = DefaultPageSize, pageIndex: Int, completion: @escaping ApiCompletion) {
        let parameters: [String: AnyObject?] = [
            "page_size": pageSize as Optional<AnyObject>,
            "page_index": pageIndex as Optional<AnyObject>
        ]
        let endpoint = String(format:GetShopByFeatureAndCategory, feature.rawValue, couponType)
        ApiManager.processRequest(endpoint, method: .GET, parameters: parameters, completion: completion)
    }
    
    static func getShopByFeature(_ feature: CouponFeature, pageSize:Int = DefaultPageSize, pageIndex: Int, completion: @escaping ApiCompletion) {
        let parameters: [String: AnyObject?] = [
            "page_size": pageSize as Optional<AnyObject>,
            "page_index": pageIndex as Optional<AnyObject>
        ]
        let endpoint = String(format:GetShopByFeature, feature.rawValue)
        ApiManager.processRequest(endpoint, method: .GET, parameters: parameters, completion: completion)
    }
    
    static func getShopByLattitudeAndLongitude(_ lattitude: Double, longitude: Double, pageSize:Int = DefaultPageSize, pageIndex: Int, completion: @escaping ApiCompletion) {
        let parameters: [String: AnyObject?] = [
            "page_size": pageSize as Optional<AnyObject>,
            "page_index": pageIndex as Optional<AnyObject>
        ]
        let endpoint = String(format:GetShopByLattitudeAndLongitude, lattitude, longitude)
        ApiManager.processRequest(endpoint, method: .GET, parameters: parameters, completion: completion)
    }
    
    static func likeCoupon(_ couponId: Float, completion: @escaping ApiCompletion) {
        let parameters: [String: AnyObject?] = [
            "id": "\(Int(couponId))" as Optional<AnyObject>,
        ]
        ApiManager.processRequest(LikeCoupon, method: .POST, parameters: parameters, hasAuth: true, completion: completion)
    }

}
