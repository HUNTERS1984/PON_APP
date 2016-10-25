//
//  BaseTabBarController.swift
//  PonApp
//
//  Created by OSXVN on 9/2/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {
    
    private var menuContainerView: UIView!
    var sideMenuView: SideMenuView!
    
    //MARK: - Public
    var selectedMenuItemIndex: Int!
    var menuItems = [String]()
    var menuDisplayed: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupMenuView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension BaseTabBarController {
    
    fileprivate func setupMenuView() {
        self.menuDisplayed = false
        menuItems = ["QR", "Point"]
        let window = UIApplication.shared.delegate?.window!
        let size = window!.bounds.size
        sideMenuView = SideMenuView.loadViewFromNib() as! SideMenuView!
        sideMenuView.frame = CGRect(x:0, y:0, width:size.width, height:size.height)
        window?.addSubview(sideMenuView)
        window?.sendSubview(toBack: sideMenuView)
    }
    
    func animateMenu(displayed: Bool, updated: Bool, alphaAnimated: Bool) {
        menuDisplayed = displayed
        var frame = self.view.frame
        loggingPrint(frame.origin.x)
        if displayed {
            frame.origin.x = 240
        }else {
            frame.origin.x = 0
        }
        
        loggingPrint(frame.origin.x)
        let baseDuration: CGFloat = 3.0
        if !displayed {
            let duration: Double = (Double)(self.view.frame.origin.x / (CGFloat)(240 * baseDuration))
            loggingPrint("duration \(duration)")
            UIView.animate(withDuration: duration, animations: {
                self.view.frame = frame
                }, completion: { _ in
                    if updated {
   
                    }
            })
        }else {
            let duration: Double = (Double)((240.0 - self.view.frame.origin.x) / (CGFloat)(240 * baseDuration))
            loggingPrint("duration \(duration)")
            UIView.animate(withDuration: duration, animations: {
                self.view.frame = frame
                }, completion: { _ in
                    if updated {

                    }
            })
        }
    }
    
    func displayMenu() {
        animateMenu(displayed: !menuDisplayed, updated: false, alphaAnimated: true)
    }
    
}
