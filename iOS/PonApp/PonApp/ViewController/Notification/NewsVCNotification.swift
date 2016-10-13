//
//  NewsVCNotification.swift
//  PonApp
//
//  Created by HaoLe on 10/13/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

extension NewsViewController {

    func processRemoteNotificationLauchApp() {
        if self.appDelegate.isRemoteNotification {
            let notificationType = NotificationManager.shared.notificationType
            if let _ = notificationType {
                if notificationType! == "new_news"{
                    let vc = NewsDetailViewController.instanceFromStoryBoard("Account") as! NewsDetailViewController
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
                    let vc = NewsDetailViewController.instanceFromStoryBoard("Account") as! NewsDetailViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    

    
}
