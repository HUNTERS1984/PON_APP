//
//  AccountVCNotification.swift
//  PonApp
//
//  Created by HaoLe on 10/13/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

extension AccountViewController {

    func registerProcessNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.processRemoteNotificationBackgroundMode), name: Notification.Name("NewNewsPushNotification"), object: nil)
    }
    
    func processRemoteNotificationLauchApp() {
        if self.appDelegate.isRemoteNotification {
            let notificationType = NotificationManager.shared.notificationType
            if let _ = notificationType {
                if notificationType! == "new_news"{
                    _ = self.navigationController?.popToRootViewController(animated: false)
                    let vc = NewsViewController.instanceFromStoryBoard("Account") as! NewsViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    func processRemoteNotificationBackgroundMode() {
        if self.appDelegate.isRemoteNotification {
            let notificationType = NotificationManager.shared.notificationType
            if let _ = notificationType {
                if notificationType! == "new_news" {
                    self.tabBarController?.selectedIndex = 2
                    _ = self.navigationController?.popToRootViewController(animated: false)
                    let vc = NewsViewController.instanceFromStoryBoard("Account") as! NewsViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
}
