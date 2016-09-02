//
//  HLKSharedResources.swift
//  CouponFinder
//
//  Created by HaoLe on 12/11/15.
//  Copyright © 2015 HaoLe. All rights reserved.
//

import UIKit

class HLKSharedResources {
    
    private var data: NSMutableDictionary!
    private var queue: dispatch_queue_t!
    
    class var sharedInstance: HLKSharedResources {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: HLKSharedResources? = nil
            
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = HLKSharedResources()
            Static.instance?.commonInit()
        }
        return Static.instance!
    }
    
    private func commonInit() {
        data = NSMutableDictionary()
        queue = dispatch_queue_create("HLKSharedResources", nil)
    }
    
    func SR_setValue(value: AnyObject, forKey key: String) {
        dispatch_sync(queue, { () -> Void in
            self.data.setValue(value, forKey: key)
        })
    }
    
    func SR_valueForKey(key: String) -> AnyObject? {
        var value: AnyObject? = nil
        dispatch_sync(queue, { () -> Void in
            value = self.data.valueForKey(key)
        })
        return value
    }
    
    func SR_removeAllResources() {
        dispatch_sync(queue, { () -> Void in
            self.data.removeAllObjects()
        })
    }
    
    class func SR_setValue(value: AnyObject, forKey key: String) {
        HLKSharedResources.sharedInstance.SR_setValue(value, forKey: key)
    }
    
    class func SR_valueForKey(key: String) -> AnyObject? {
        return HLKSharedResources.sharedInstance.SR_valueForKey(key)
    }
    
    class func SR_removeAllResources() {
        HLKSharedResources.sharedInstance.SR_removeAllResources()
    }
    
}