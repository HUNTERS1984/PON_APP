//
//  MainVCNotification.swift
//  PonApp
//
//  Created by HaoLe on 10/11/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

extension MainViewController {
    
    func registerProcessNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.processRemoteNotificationBackgroundMode), name: Notification.Name("NewCouponPushNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.processRemoteNewsNotificationBackgroundMode), name: Notification.Name("NewNewsPushNotification"), object: nil)
    }
    
    func processRemoteNewsNotificationLauchApp() {
        if self.appDelegate.isRemoteNotification {
            let notificationType = NotificationManager.shared.notificationType
            if let _ = notificationType {
                if notificationType! == "new_news" {
                    self.tabBarController?.selectedIndex = 2
                    NotificationCenter.default.addObserver(self, selector: #selector(self.processRemoteNewsNotificationBackgroundMode), name: Notification.Name("NewNewsPushNotification"), object: nil)
                }
            }
        }
    }
    
    func processRemoteNewsNotificationBackgroundMode() {
        if self.appDelegate.isRemoteNotification {
            let notificationType = NotificationManager.shared.notificationType
            if let _ = notificationType {
                if notificationType! == "new_news" {
                    self.tabBarController?.selectedIndex = 2
                }
            }
        }
    }
    
    func processRemoteNotificationLauchApp() {
        if self.appDelegate.isRemoteNotification {
            let notificationType = NotificationManager.shared.notificationType
            if let _ = notificationType {
                if notificationType! == "new_coupon" || notificationType! == "coupon_approved" {
                    self.getCouponDetail(NotificationManager.shared.dataId!)
                }
            }
        }
    }
    
    func processRemoteNotificationBackgroundMode() {
        if self.appDelegate.isRemoteNotification {
            let notificationType = NotificationManager.shared.notificationType
            if let _ = notificationType {
                if notificationType! == "new_coupon" || notificationType! == "coupon_approved" {
                    self.tabBarController?.selectedIndex = 1
                    _ = self.navigationController?.popToRootViewController(animated: false)
                    self.getCouponDetail(NotificationManager.shared.dataId!)
                }
            }
        }
    }
    
    func getCouponDetail(_ couponId: Float) {
        ApiRequest.getCouponDetail(couponId, hasAuth: UserDataManager.isLoggedIn()) { (request: URLRequest?, result: ApiResponse?, error: NSError?) in
            if let _ = error {
                
            }else {
                if result?.code == SuccessCode {
                    let coupon = Coupon(response: result?.data)
                    let vc = CouponViewController.instanceFromStoryBoard("Coupon") as! CouponViewController
                    vc.coupon = coupon
                    self.navigationController?.pushViewController(vc, animated: true)
                }else {
                    self.presentAlert(message: (result?.message)!)
                }
            }
        }
    }
}

