//
//  ShareCouponManager.swift
//  PonApp
//
//  Created by HaoLe on 10/14/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit
import Social

struct ShareCouponManager {
    
    static var shared: ShareCouponManager {
        struct Static {
            static let instance = ShareCouponManager()
        }
        return Static.instance
    }
    
    //MARK: - Facebook
    func presentShareCouponToFacebook(_ viewControllerToPresent: UIViewController, initialText: String = "Test post from my iPhone", url: String = "http://pon.cm/", image: UIImage? = nil) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            let controller = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            controller?.setInitialText(initialText)
            controller?.add(URL(string: url))
            if let _ = image {
                controller?.add(image!)
            }
            viewControllerToPresent.present(controller!, animated: true)
        }else {
            UIAlertController.present(title: "Alert", message: "Facebook Account is not available on your device", actionTitles: ["OK"])
        }
    }
    
    //MARK: - Twitter
    func presentShareCouponToTwitter(_ viewControllerToPresent: UIViewController, initialText: String = "Test post from my iPhone", url: String = "http://pon.cm/", image: UIImage? = nil) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            let controller = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            controller?.setInitialText(initialText)
            controller?.add(URL(string: url))
            if let _ = image {
                controller?.add(image!)
            }
            viewControllerToPresent.present(controller!, animated: true)
        }else {
            UIAlertController.present(title: "Alert", message: "Twitter Account is not available on your device", actionTitles: ["OK"])
        }
    }

}
