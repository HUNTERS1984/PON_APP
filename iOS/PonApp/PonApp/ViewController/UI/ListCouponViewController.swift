//
//  ListCouponViewController.swift
//  PonApp
//
//  Created by HaoLe on 9/8/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class ListCouponViewController: BaseViewController {
    
    var pageMenu : CAPSPageMenu?
    var couponType: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        self.title = "グルメでさがす"
        self.showBackButton()
        self.setupScrollMenu()
    }
}

//IBAction
extension ListCouponViewController {
    
}

extension ListCouponViewController {
    
    internal func setupScrollMenu() {
        var controllerArray : [UIViewController] = []
        
        let popular = ListCouponContentViewController.instanceFromStoryBoard("CouponList") as! ListCouponContentViewController
        popular.parentNavigationController = self.navigationController
        popular.couponFeature = .Popularity
        popular.couponType = self.couponType
        popular.title = "人気"
        controllerArray.append(popular)
        
        let newest = ListCouponContentViewController.instanceFromStoryBoard("CouponList") as! ListCouponContentViewController
        newest.parentNavigationController = self.navigationController
        newest.couponFeature = .NewArrival
        newest.couponType = self.couponType
        newest.title = "新着"
        controllerArray.append(newest)
        
        let nearest = ListCouponContentViewController.instanceFromStoryBoard("CouponList") as! ListCouponContentViewController
        nearest.parentNavigationController = self.navigationController
        nearest.couponFeature = .Near
        nearest.couponType = self.couponType
        nearest.title = "近く"
        controllerArray.append(nearest)
        
        let deal = ListCouponContentViewController.instanceFromStoryBoard("CouponList") as! ListCouponContentViewController
        deal.parentNavigationController = self.navigationController
        deal.couponFeature = .Deal
        deal.couponType = self.couponType
        deal.title = "お得"
        controllerArray.append(deal)
        
        let parameters: [CAPSPageMenuOption] = [
            .MenuItemSeparatorWidth(4.3),
            .ScrollMenuBackgroundColor(UIColor.whiteColor()),
            .ViewBackgroundColor(UIColor.whiteColor()),
            .BottomMenuHairlineColor(UIColor(hex: 0xe1e3e5)),
            .SelectionIndicatorColor(UIColor(hex: 0x18c0d4)),
            .MenuItemWidth(70.0),
            .MenuHeight(self.view.bounds.size.height * (50/667)),
            .SelectedMenuItemLabelColor(UIColor(hex: 0x29c9c9)),
            .UnselectedMenuItemLabelColor(UIColor(hex: 0xa9e9e9)),
            .MenuItemFont(UIFont.HiraginoSansW6(17)),
            .MenuItemSeparatorRoundEdges(true),
            .SelectionIndicatorHeight(2.0),
            .MenuItemSeparatorPercentageHeight(0.1)
        ]
        
        // Initialize scroll menu
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height), pageMenuOptions: parameters)
        pageMenu!.delegate = self
        self.view.addSubview(pageMenu!.view)
    }
    
}

extension ListCouponViewController: CAPSPageMenuDelegate {
    
    func didMoveToPage(controller: UIViewController, index: Int) {
    
    }
    
    func willMoveToPage(controller: UIViewController, index: Int) {

    }
    
}