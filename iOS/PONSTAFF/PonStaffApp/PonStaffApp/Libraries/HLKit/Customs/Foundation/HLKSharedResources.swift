//
//  HLKSharedResources.swift
//  CouponFinder
//
//  Created by HaoLe on 12/11/15.
//  Copyright © 2015 HaoLe. All rights reserved.
//

import UIKit

class HLKSharedResources {
    
    fileprivate var data: NSMutableDictionary!
    fileprivate var queue: DispatchQueue!
    
    class var sharedInstance: HLKSharedResources {
        struct Static {
            static let instance = HLKSharedResources()
        }
        return Static.instance
    }
    
    fileprivate func commonInit() {
        data = NSMutableDictionary()
        queue = DispatchQueue(label: "HLKSharedResources", attributes: [])
    }
    
    func SR_setValue(_ value: AnyObject, forKey key: String) {
        queue.sync(execute: { () -> Void in
            self.data.setValue(value, forKey: key)
        })
    }
    
    func SR_valueForKey(_ key: String) -> AnyObject? {
        var value: AnyObject? = nil
        queue.sync(execute: { () -> Void in
            value = self.data.value(forKey: key) as AnyObject?
        })
        return value
    }
    
    func SR_removeAllResources() {
        queue.sync(execute: { () -> Void in
            self.data.removeAllObjects()
        })
    }
    
    class func SR_setValue(_ value: AnyObject, forKey key: String) {
        HLKSharedResources.sharedInstance.SR_setValue(value, forKey: key)
    }
    
    class func SR_valueForKey(_ key: String) -> AnyObject? {
        return HLKSharedResources.sharedInstance.SR_valueForKey(key)
    }
    
    class func SR_removeAllResources() {
        HLKSharedResources.sharedInstance.SR_removeAllResources()
    }
    
}
