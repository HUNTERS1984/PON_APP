//
//  ApiFileUpload.swift
//  PonApp
//
//  Created by HaoLe on 9/23/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

public struct ApiFileUpload {
    var data: NSData?
    var name: String
    var fileName: String
    var mimeType: String
    
    init(data: NSData, name: String, fileName: String, mimeType: String? = nil) {
        self.data = data
        self.name = name
        self.fileName = fileName
        self.mimeType = "application/octet-stream"
        
        if let mimeType = mimeType {
            switch mimeType.lowercaseString {
            case "jpeg", "jpg":
                self.mimeType = "image/jpeg"
            case "png":
                self.mimeType = "image/png"
            default:
                self.mimeType = "application/octet-stream"
            }
        }
    }
    
}