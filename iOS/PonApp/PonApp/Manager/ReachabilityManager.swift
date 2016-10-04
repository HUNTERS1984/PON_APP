//
//  ReachabilityManager.swift
//  PonApp
//
//  Created by OSXVN on 10/1/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class ReachabilityManager {
    
    class var sharedInstance: ReachabilityManager {
        struct Static {
            static let instance = ReachabilityManager()
        }
        return Static.instance
    }
    
    var reachability: Reachability!
    
    //MARK: - Private methods
    
    func initReachabilityManager() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityDidChange(_:)), name: NSNotification.Name(rawValue: "ReachabilityChangedNotification"), object: nil)
        self.reachability = Reachability.forInternetConnection()
        self.reachability.startNotifier()
    }
    
    @objc func reachabilityDidChange(_ notification: Notification) {

    }
    
    //MARK: - Public methods
    static func isReachable() -> Bool {
        return ReachabilityManager.sharedInstance.reachability.isReachable()
    }
    
    static func isUnreachable() -> Bool {
        return !ReachabilityManager.sharedInstance.reachability.isReachable()
    }
    
}
