//
//  ShareCouponManager.swift
//  PonApp
//
//  Created by HaoLe on 10/14/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit
import Social

class ShareCouponManager: NSObject {
    
    private let documentInteractionController = UIDocumentInteractionController()
    
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
    
    //MARK: - Instagram
    
    func postImageToInstagramWithCaption(imageInstagram: UIImage, instagramCaption: String, view: UIView) {
        let kInstagramURL = "instagram://"
        let kUTI = "com.instagram.exclusivegram"
        let kfileNameExtension = "instagram.igo"
        let kAlertViewTitle = "Error"
        let kAlertViewMessage = "Please install the Instagram application"
        
        let instagramURL = URL(string: kInstagramURL)
        if UIApplication.shared.canOpenURL(instagramURL!) {
            let jpgPath = (NSTemporaryDirectory() as NSString).appendingPathComponent(kfileNameExtension)
            do {
                try UIImageJPEGRepresentation(imageInstagram, 1.0)!.write(to: URL(fileURLWithPath: jpgPath), options: .atomic)
            } catch {
                print(error)
            }
            let rect = CGRect.zero
            let fileURL = NSURL.fileURL(withPath: jpgPath)
            documentInteractionController.url = fileURL
            documentInteractionController.delegate = self
            documentInteractionController.uti = kUTI
            
            // adding caption for the image
            documentInteractionController.annotation = ["InstagramCaption": instagramCaption]
            documentInteractionController.presentOpenInMenu(from: rect, in: view, animated: true)
        }
        else {
            // alert displayed when the instagram application is not available in the device
            UIAlertController.present(title: kAlertViewTitle, message: kAlertViewMessage, actionTitles: ["OK"])
        }
    }
    
    //MARK: LINE
    func shareLine() {
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"line://msg/text/%@", [text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
        UIApplication.shared.openURL(URL(string: "line://msg/text/con chim non")!)
    }

}

extension ShareCouponManager: UIDocumentInteractionControllerDelegate {
    
}
