//
//  ApiFileUpload.swift
//  PonApp
//
//  Created by HaoLe on 9/23/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

public struct ApiFileUpload {
    var data: Data?
    var name: String
    var fileName: String
    var mimeType: String
    
    init(data: Data, name: String, fileName: String, mimeType: String? = nil) {
        self.data = data
        self.name = name
        self.fileName = fileName
        self.mimeType = "application/octet-stream"
        
        if let mimeType = mimeType {
            switch mimeType.lowercased() {
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
