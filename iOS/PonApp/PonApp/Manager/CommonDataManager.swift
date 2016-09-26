//
//  CommonDataManager.swift
//  PonApp
//
//  Created by HaoLe on 9/26/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class CommonDataManager: NSObject {
    
    class var sharedInstance: CommonDataManager {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: CommonDataManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = CommonDataManager()
        }
        return Static.instance!
    }
    
}
