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
    
    static func initPush(with application: UIApplication, launchOptions:[UIApplicationLaunchOptionsKey: Any]?, appId: String) {
        OneSignal.setLogLevel(.LL_INFO, visualLevel: .LL_NONE)
        OneSignal.initWithLaunchOptions(launchOptions, appId: OneSignalAppID, handleNotificationReceived: { (notification) in
                NotificationManager.shared.handleNotificationReceived(with: notification)
            }, handleNotificationAction: { (result) in
                // This block gets called when the user reacts to a notification received
                NotificationManager.shared.handleNotificationAction(with: result)
                
            }, settings: [kOSSettingsKeyAutoPrompt : true, kOSSettingsKeyInAppAlerts : false])
    }
    
    static func registerForPushNotifications(application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
}
 
