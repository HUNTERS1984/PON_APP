//
//  ApiRequest.swift
//  PonApp
//
//  Created by HaoLe on 9/23/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

public struct ApiRequest {
    
    static func signUp(userName: String, email: String, password: String, completion: ApiCompletion) {
        let parameters: [String: AnyObject?] = [
            "username": userName,
            "email": email,
            "plainPassword": password
        ]
        ApiManager.processRequest(SignUp, method: .POST, parameters: parameters, completion: completion)
    }
    
    static func signIn(userName: String, password: String, completion: ApiCompletion) {
        let parameters: [String: AnyObject?] = [
            "username": userName,
            "plainPassword": password
        ]
        ApiManager.processRequest(SignUp, method: .POST, parameters: parameters, hasAuth: false, completion: completion)
    }
    
    static func signOut(userName: String, password: String, completion: ApiCompletion) {
        let parameters: [String: AnyObject?] = [
            "username": userName,
            "plainPassword": password
        ]
        ApiManager.processRequest(SignUp, method: .POST, parameters: parameters, hasAuth: false, completion: completion)
    }

}
