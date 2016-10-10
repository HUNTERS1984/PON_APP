//
//  NotificationManager.swift
//  PonApp
//
//  Created by HaoLe on 10/10/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit
import OneSignal

struct NotificationManager {
    
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
        let payload = notification?.notification.payload
        let title = payload?.title
        let body = payload?.body
        let subtitle = payload?.subtitle
        
        if let actionSelected = notification?.action.actionID {
            let message =  "title: + \(title)"  + "\nbody: \(body)" + "\nsubtitle: \(subtitle)" + "\nadditionalData: \(payload?.additionalData)" + "\nPressed ButtonId: \(actionSelected)"
            print(message)
        }
    }
    
}
