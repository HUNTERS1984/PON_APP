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
    }
    
    func processRemoteNotificationLauchApp() {
        if self.appDelegate.isRemoteNotification {
            let notification = JSON(self.appDelegate.remoteNotificationData!)
            let notificationType = notification["notification_type"].stringValue
            if notificationType == "new_coupon" {
                let id = notification["id"].floatValue
                self.getCouponDetail(id)
            }
        }
    }
    
    func processRemoteNotificationBackgroundMode() {
        if self.appDelegate.isRemoteNotification {
            let notification = JSON(self.appDelegate.remoteNotificationData!)
            let notificationType = notification["notification_type"].stringValue
            if notificationType == "new_coupon" {
                self.tabBarController?.selectedIndex = 1
                _ = self.navigationController?.popToRootViewController(animated: false)
                let id = notification["id"].floatValue
                self.getCouponDetail(id)
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

