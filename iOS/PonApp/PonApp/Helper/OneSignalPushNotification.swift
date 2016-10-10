//
//  OneSignalPushNotification.swift
//  PonApp
//
//  Created by OSXVN on 10/9/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit
import OneSignal

struct OneSignalPushNotification {
    
    static func initPush(with launchOptions:[UIApplicationLaunchOptionsKey: Any]?, appId: String) {
        OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
        OneSignal.initWithLaunchOptions(launchOptions, appId: OneSignalAppID, handleNotificationReceived: { (notification) in
                print("Received Notification - \(notification?.payload.notificationID)")
            }, handleNotificationAction: { (result) in
                
                // This block gets called when the user reacts to a notification received
                let payload = result?.notification.payload
                var fullMessage = payload?.title
                
                //Try to fetch the action selected
                if let actionSelected = result?.action.actionID {
                    fullMessage =  fullMessage! + "\nPressed ButtonId:\(actionSelected)"
                }
                
                print(fullMessage)
                
            }, settings: [kOSSettingsKeyAutoPrompt : false, kOSSettingsKeyInAppAlerts : false])
        
        
        // iOS 10 ONLY - Add category for the OSContentExtension
        // Make sure to add UserNotifications framework in the Linked Frameworks & Libraries.
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationCategories { (categories) in
                let myAction = UNNotificationAction(identifier: "action0", title: "Hit Me!", options: .foreground)
                let myCategory = UNNotificationCategory(identifier: "myOSContentCategory", actions: [myAction], intentIdentifiers: [], options: .customDismissAction)
                let mySet = NSSet(array: [myCategory]).addingObjects(from: categories) as! Set<UNNotificationCategory>
                UNUserNotificationCenter.current().setNotificationCategories(mySet)
            }
        }
        
    }

}
 
