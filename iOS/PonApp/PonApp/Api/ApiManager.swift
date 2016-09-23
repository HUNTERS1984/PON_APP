//
//  ApiManager.swift
//  PonApp
//
//  Created by HaoLe on 9/21/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

typealias ApiCompletion = (request: NSURLRequest?, result: Any?, error: NSError?) -> Void

public enum ApiMethod: String {
    case GET, POST, PUT
}

public struct ApiManager {
    
    private static func getBaseApiURL() -> String {
        return BaseURL
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
    
    static func processRequest(endpoint: String, method: ApiMethod, parameters: [String: AnyObject?]? = nil, uploadFiles: [ApiFileUpload]? = nil, hasAuth: Bool = true, completion: ApiCompletion) {
        // Compose full-path of URL request
        let url = getBaseApiURL() + endpoint
        let standardParams = ApiManager.standardizeParameter(parameters)
        switch method {
        case .GET:
            if parameters != nil {
                ApiManager.processGetRequest(url, parameters: standardParams, completion: completion)
            } else {
                ApiManager.processGetRequest(url, completion: completion)
            }
            
        case .POST:
            if let uploadFiles = uploadFiles {
                ApiManager.processPostWithMultipartFormDataRequest(url, parameters: standardParams, uploadFiles: uploadFiles, completion: completion)
            }else {
                ApiManager.processPostRequest(url, parameters: standardParams, completion: completion)
            }
        case .PUT:
            if let _ = uploadFiles {

            }else {

            }
        }
    }
    
    //MARK: - GET
    private static func processGetRequest(urlString: String, parameters: [String: AnyObject]? = nil, completion: ApiCompletion) {
        let completionHandler = {(response: Response<String, NSError>) -> Void in
            if response.result.isSuccess {
                ApiManager.processSuccessResponese(response, completion: completion)
            }else {
                ApiManager.processFailureResponese(response.result.error!, completion: completion)
            }
        }
        if let parameters = parameters {
            Alamofire.request(
                .GET,
                urlString,
                parameters: parameters
                ).responseString(completionHandler: completionHandler)
        }else {
            Alamofire.request(.GET, urlString).responseString(completionHandler: completionHandler)
        }
    }
    
    //MARK: - POST
    private static func processPostRequest(urlString: String, parameters: [String: AnyObject], completion: ApiCompletion) {
        let completionHandler = {(response: Response<String, NSError>) -> Void in
            if response.result.isSuccess {
                ApiManager.processSuccessResponese(response, completion: completion)
            }else {
                ApiManager.processFailureResponese(response.result.error!, completion: completion)
            }
        }
        Alamofire.request(.POST, urlString, parameters: parameters, encoding: .JSON).responseString(completionHandler: completionHandler)
    }
    
    //MARK: - MULTIPART POST
    private static func processPostWithMultipartFormDataRequest(urlString: String, parameters: [String: AnyObject], uploadFiles: [ApiFileUpload], completion: ApiCompletion) {
        let encodingCompletion = { (encodingResult: Alamofire.Manager.MultipartFormDataEncodingResult) -> Void in
            switch encodingResult {
            case .Success(let upload, _, _):
                upload.responseJSON { response in
                    upload.responseString { response in
                        if response.result.isSuccess {
                            ApiManager.processSuccessResponese(response, completion: completion)
                        }else {
                            ApiManager.processFailureResponese(response.result.error!, completion: completion)
                        }
                    }
                }
            case .Failure(let encodingError):
                ApiManager.processFailureResponese(encodingError, completion: completion)
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
        Alamofire.upload(.POST, urlString, multipartFormData: multipartFormData, encodingCompletion:encodingCompletion)
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
            let error = NSError(domain: "IApi Error", code: 1, userInfo: ["error":"Unable to decrypt data"])
            completion(request: nil, result: nil, error: error)
        }
    }
    
    //MARK: - FAILURE RESPONSE
    private static func processFailureResponese(encodingError: ErrorType, completion: ApiCompletion) {
        let error = NSError(domain: "IApi Error", code: 1, userInfo: ["error":"\(encodingError)"])
        completion(request: nil, result: nil, error: error)
    }
    
}
