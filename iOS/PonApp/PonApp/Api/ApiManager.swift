//
//  ApiManager.swift
//  PonApp
//
//  Created by HaoLe on 9/21/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

typealias ApiCompletion = (request: NSURLRequest?, result: ApiResponse?, error: NSError?) -> Void

public enum ApiMethod: String {
    case GET, POST
}

public struct ApiManager {
    
    private static func getBaseApiURL() -> String {
        return BaseURL
    }
    
    private static func getToken() -> String {
        if let _ = Defaults[.token] {
            return Defaults[.token]!
        }else {
            return ""
        }
    }
    
    private static func standardizeParameter(parameters: [String: AnyObject?]?) -> [String: AnyObject] {
        var standarParameter = [String: AnyObject]()
        if let parameters = parameters {
            for (key, value) in parameters {
                if (value != nil) {
                    standarParameter[key] = value
                }
            }
        }
        return standarParameter;
    }
    
    static func processRequest(endpoint: String, method: ApiMethod, parameters: [String: AnyObject?]? = nil, uploadFiles: [ApiFileUpload]? = nil, hasAuth: Bool = false, completion: ApiCompletion) {
        if !ReachabilityManager.isReachable() {
            let error = NSError(domain: "PON", code: 1, userInfo: ["error":"\(NotConnectInternet)"])
            completion(request: nil, result: nil, error: error)
        }else {
            // Compose full-path of URL request
            let url = getBaseApiURL() + endpoint
            let standardParams = ApiManager.standardizeParameter(parameters)
            switch method {
            case .GET:
                if parameters != nil {
                    ApiManager.processGetRequest(url, parameters: standardParams, hasAuth: hasAuth, completion: completion)
                } else {
                    ApiManager.processGetRequest(url, hasAuth: hasAuth, completion: completion)
                }
                
            case .POST:
                if let uploadFiles = uploadFiles {
                    ApiManager.processPostWithMultipartFormDataRequest(url, parameters: standardParams, uploadFiles: uploadFiles, hasAuth: hasAuth, completion: completion)
                }else {
                    ApiManager.processPostRequest(url, parameters: standardParams, hasAuth: hasAuth, completion: completion)
                }
            }
        }
    }
    
    //MARK: - GET
    private static func processGetRequest(urlString: String, parameters: [String: AnyObject]? = nil, hasAuth: Bool = false, completion: ApiCompletion) {
        let completionHandler = {(response: Response<String, NSError>) -> Void in
            if response.result.isSuccess {
                ApiManager.processSuccessResponese(response, completion: completion)
            }else {
                ApiManager.processFailureResponese(response, completion: completion)
            }
        }
        let headers = [
            "Authorization": "Bearer \(self.getToken())"
        ]
        
        if let parameters = parameters {
            if hasAuth {
                Alamofire.request(.GET, urlString, parameters: parameters, headers: headers).validate().responseString(completionHandler: completionHandler)
            }else {
                Alamofire.request(.GET, urlString, parameters: parameters).validate().responseString(completionHandler: completionHandler)
            }
        }else {
            if hasAuth {
                Alamofire.request(.GET, urlString, headers: headers).validate().responseString(completionHandler: completionHandler)
            }else {
                Alamofire.request(.GET, urlString).validate().responseString(completionHandler: completionHandler)
            }
        }
    }
    
    //MARK: - POST
    private static func processPostRequest(urlString: String, parameters: [String: AnyObject], hasAuth: Bool = false, completion: ApiCompletion) {
        let completionHandler = {(response: Response<String, NSError>) -> Void in
            if response.result.isSuccess {
                ApiManager.processSuccessResponese(response, completion: completion)
            }else {
                ApiManager.processFailureResponese(response, completion: completion)
            }
        }
        let headers = [
            "Authorization": "Bearer \(self.getToken())"
        ]
        if hasAuth {
            Alamofire.request(.POST, urlString, parameters: parameters, encoding: .JSON, headers: headers).validate().responseString(completionHandler: completionHandler)
        }else {
            Alamofire.request(.POST, urlString, parameters: parameters, encoding: .JSON).validate().responseString(completionHandler: completionHandler)
        }
    }
    
    //MARK: - MULTIPART POST
    private static func processPostWithMultipartFormDataRequest(urlString: String, parameters: [String: AnyObject], uploadFiles: [ApiFileUpload], hasAuth: Bool = false, completion: ApiCompletion) {
        let encodingCompletion = { (encodingResult: Alamofire.Manager.MultipartFormDataEncodingResult) -> Void in
            switch encodingResult {
            case .Success(let upload, _, _):
                upload.responseJSON { response in
                    upload.responseString { response in
                        if response.result.isSuccess {
                            ApiManager.processSuccessResponese(response, completion: completion)
                        }else {
                            ApiManager.processFailureResponese(response, completion: completion)
                        }
                    }
                }
            case .Failure( _):
                ApiManager.processFailureResponese(nil, completion: completion)
            }
        }
        
        let multipartFormData = {(multipartFormData: Alamofire.MultipartFormData) -> Void in
            for file in uploadFiles {
                multipartFormData.appendBodyPart(data: file.data!, name: file.name, fileName: file.fileName, mimeType: file.mimeType)
            }
            
            for (key, value) in parameters {
                multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
            }
        }
        
        let headers = [
            "Authorization": "Bearer \(self.getToken())"
        ]
        if hasAuth {
            Alamofire.upload(.POST, urlString, headers: headers, multipartFormData: multipartFormData, encodingCompletion:encodingCompletion)
        }else {
            Alamofire.upload(.POST, urlString, multipartFormData: multipartFormData, encodingCompletion:encodingCompletion)
        }
    }
    
    //MARK: - SUCCESS RESPONSE
    private static func processSuccessResponese(response: Response<String, NSError>, completion: ApiCompletion) {
        let urlRequest = response.request
        let resultString = response.result.value
        let json = JSON(data: (resultString?.dataUsingEncoding(NSUTF8StringEncoding))!)
        print("RESPONSE JSON: \(json)")
        
        if json != nil {
            let response = ApiResponse(response: json)
            completion(request: urlRequest, result: response, error: nil)
        }else {
            let error = NSError(domain: "PON", code: 1, userInfo: ["error":"PON Api Error"])
            completion(request: nil, result: nil, error: error)
        }
    }
    
    //MARK: - FAILURE RESPONSE
    private static func processFailureResponese(response: Response<String, NSError>?, completion: ApiCompletion) {
        if let httpStatusCode = response!.response?.statusCode {
            if httpStatusCode == 401 {
                ApiManager.processInvalidToken()
            }
            let encodingError = response!.result.error!
            let error = NSError(domain: "PON", code: 1, userInfo: ["error":"\(encodingError)"])
            completion(request: nil, result: nil, error: error)
        }
    }
    
    private static func processInvalidToken() {
        Defaults[.token] = nil
        NSNotificationCenter.defaultCenter().postNotificationName(TokenInvalidNotification, object: nil)
    }
    
}
