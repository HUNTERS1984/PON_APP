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

typealias ApiCompletion = (_ request: URLRequest?, _ result: ApiResponse?, _ error: NSError?) -> Void

public enum ApiMethod: String {
    case GET, POST
}

public struct ApiManager {
    
    fileprivate static func getBaseApiURL() -> String {
        return BaseURL
    }
    
    fileprivate static func getToken() -> String {
        if let _ = Defaults[.token] {
            return Defaults[.token]!
        }else {
            return ""
        }
    }
    
    fileprivate static func standardizeParameter(_ parameters: [String: String?]?) -> [String: String] {
        var standarParameter = [String: String]()
        if let parameters = parameters {
            for (key, value) in parameters {
                if (value != nil) {
                    standarParameter[key] = value
                }
            }
        }
        return standarParameter;
    }
    
    static func processRequest(_ endpoint: String, method: ApiMethod, parameters: [String: String?]? = nil, uploadFiles: [ApiFileUpload]? = nil, hasAuth: Bool = false, completion: @escaping (ApiCompletion) ) {
        if !ReachabilityManager.isReachable() {
            let error = NSError(domain: "PON", code: 1, userInfo: ["error":"\(NotConnectInternet)"])
            completion(nil, nil, error)
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
    fileprivate static func processGetRequest(_ urlString: String, parameters: [String: String]? = nil, hasAuth: Bool = false, completion: @escaping (ApiCompletion) ) {
        let completionHandler = {(response: DataResponse<String>) -> Void in
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
                Alamofire.request(urlString, method: .get, parameters: parameters, headers: headers).validate().responseString(completionHandler: completionHandler)
            }else {
                Alamofire.request(urlString, method: .get, parameters: parameters).validate().responseString(completionHandler: completionHandler)
            }
        }else {
            if hasAuth {
                Alamofire.request(urlString, method: .get, headers: headers).validate().responseString(completionHandler: completionHandler)
            }else {
                Alamofire.request(urlString, method: .get).validate().responseString(completionHandler: completionHandler)
            }
        }
    }
    
    //MARK: - POST
    fileprivate static func processPostRequest(_ urlString: String, parameters: [String: String], hasAuth: Bool = false, completion: @escaping (ApiCompletion) ) {
        let completionHandler = {(response: DataResponse<String>) -> Void in
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
            Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseString(completionHandler: completionHandler)
        }else {
            Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseString(completionHandler: completionHandler)
        }
    }
    
    //MARK: - MULTIPART POST
    fileprivate static func processPostWithMultipartFormDataRequest(_ urlString: String, parameters: [String: String], uploadFiles: [ApiFileUpload], hasAuth: Bool = false, completion: @escaping (ApiCompletion) ) {
        let encodingCompletion = { (encodingResult: SessionManager.MultipartFormDataEncodingResult) -> Void in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    upload.responseString { response in
                        if response.result.isSuccess {
                            ApiManager.processSuccessResponese(response, completion: completion)
                        }else {
                            ApiManager.processFailureResponese(response, completion: completion)
                        }
                    }
                }
            case .failure( _):
                ApiManager.processFailureResponese(nil, completion: completion)
            }
        }
        
        let multipartFormData = {(multipartFormData: Alamofire.MultipartFormData) -> Void in
            for file in uploadFiles {
                multipartFormData.append(file.data!, withName: file.name, fileName: file.fileName, mimeType: file.mimeType)
            }
            
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }
        
        let headers = [
            "Authorization": "Bearer \(self.getToken())"
        ]
        if hasAuth {
            Alamofire.upload(multipartFormData: multipartFormData, to: urlString, method: .post, headers: headers, encodingCompletion: encodingCompletion)
        }else {
            Alamofire.upload(multipartFormData: multipartFormData, to: urlString, method: .post, encodingCompletion: encodingCompletion)
        }
    }
    
    //MARK: - SUCCESS RESPONSE
    fileprivate static func processSuccessResponese(_ response: DataResponse<String>, completion: @escaping (ApiCompletion)) {
        let urlRequest = response.request
        let resultString = response.result.value
        let json = JSON(data: (resultString?.data(using: String.Encoding.utf8))!)
        print("RESPONSE JSON: \(json)")
        
        let response = ApiResponse(response: json)
        completion(urlRequest, response, nil)
    }
    
    //MARK: - FAILURE RESPONSE
    fileprivate static func processFailureResponese(_ response: DataResponse<String>?, completion: @escaping (ApiCompletion)) {
        if let httpStatusCode = response!.response?.statusCode {
            if httpStatusCode == 401 {
                ApiManager.processInvalidToken()
            }
            let encodingError = response!.result.error!
            let error = NSError(domain: "PON", code: 1, userInfo: ["error":"\(encodingError)"])
            completion(nil, nil, error)
        }
    }
    
    fileprivate static func processInvalidToken() {
        Defaults[.token] = nil
    }
    
}
