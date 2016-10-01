//
//  ReachabilityManager.swift
//  PonApp
//
//  Created by OSXVN on 10/1/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class ReachabilityManager: NSObject {
    
    static var sharedInstance: ReachabilityManager {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: ReachabilityManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = ReachabilityManager()
            Static.instance?.initialize()
        }
        return Static.instance!
    }
    
    var reachability: Reachability!
    
    //MARK: - Private methods
    
    func initialize() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.reachabilityDidChange(_:)), name: "ReachabilityChangedNotification", object: nil)
        self.reachability = Reachability.reachabilityForInternetConnection()
        self.reachability.startNotifier()
    }
    
    func reachabilityDidChange(notification: NSNotification) {

    }
    
    //MARK: - Public methods
    static func isReachable() -> Bool {
        return ReachabilityManager.sharedInstance.reachability.isReachable()
    }
    
    static func isUnreachable() -> Bool {
        return !ReachabilityManager.sharedInstance.reachability.isReachable()
    }
    
}
