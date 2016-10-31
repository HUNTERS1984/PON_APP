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
    
    static func signIn(_ userName: String, password: String, completion: @escaping (ApiCompletion)) {
        let parameters: [String: String?] = [
            "username": userName,
            "password": password
        ]
        ApiManager.processRequest(SignIn, method: .POST, parameters: parameters, completion: completion)
    }
    
    static func signOut(_ completion: @escaping (ApiCompletion)) {
        ApiManager.processRequest(SignOut, method: .GET, hasAuth: true, completion: completion)
    }
    
    static func getRequestCoupon(_ pageSize:Int = DefaultPageSize, pageIndex: Int, completion: @escaping (ApiCompletion)) {
        let parameters: [String: String?] = [
            "page_size": "\(pageSize)",
            "page_index": "\(pageIndex)"
        ]
        ApiManager.processRequest(RequestCoupon, method: .GET, parameters: parameters, hasAuth: true, completion: completion)
    }
    
    static func getUserProfile(_ completion: @escaping (ApiCompletion)) {
        ApiManager.processRequest(UserProfile, method: .GET, hasAuth: true, completion: completion)
    }
    
    static func acceptCoupon(_ couponId: Float, userName: String, completion: @escaping(ApiCompletion)) {
        let parameters: [String: String?] = [
            "username": userName
        ]
        let endpoint = String(format:AcceptCoupon, Int(couponId), userName)
        ApiManager.processRequest(endpoint, method: .POST, parameters: parameters, hasAuth: true, completion: completion)
    }
    
    static func rejectCoupon(_ couponId: Float, userName: String, completion: @escaping(ApiCompletion)) {
        let parameters: [String: String?] = [
            "username": userName
        ]
        let endpoint = String(format:RejectCoupon, Int(couponId), userName)
        ApiManager.processRequest(endpoint, method: .POST, parameters: parameters, hasAuth: true, completion: completion)
    }

}
