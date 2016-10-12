//
//  NotificationManager.swift
//  PonApp
//
//  Created by HaoLe on 10/10/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit
import OneSignal

class NotificationManager {
    
    var notificationType: String!
    var dataId: Float!
    
    static var shared: NotificationManager {
        struct Static {
            static let instance = NotificationManager()
        }
        return Static.instance
    }
    
    func handleNotificationReceived(with notification: OSNotification?) {
        print("Received Notification - \(notification?.payload.body)")
    }
    
    func handleNotificationAction(with notification: OSNotificationOpenedResult?) {
        let additionalData = JSON(notification?.notification.payload.additionalData)
        self.notificationType = additionalData["notification_type"].stringValue
        self.dataId = additionalData["id"].floatValue
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let application = UIApplication.shared
        if ( application.applicationState == .inactive || application.applicationState == .background ){
            appDelegate.isRemoteNotification = true
            NotificationCenter.default.post(name: Notification.Name("NewCouponPushNotification"), object: nil)
        }
    }
    
}
