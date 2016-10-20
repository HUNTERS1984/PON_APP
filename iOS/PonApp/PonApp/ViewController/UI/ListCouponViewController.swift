//
//  ListCouponViewController.swift
//  PonApp
//
//  Created by HaoLe on 9/8/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class ListCouponViewController: BaseViewController {
    var categoryName: String = ""
    var pageMenu : CAPSPageMenu?
    var couponCategoryID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        self.title = self.categoryName
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
        popular.couponFeature = .popularity
        popular.couponCategoryID = self.couponCategoryID
        popular.title = "人気"
        controllerArray.append(popular)
        
        let newest = ListCouponContentViewController.instanceFromStoryBoard("CouponList") as! ListCouponContentViewController
        newest.parentNavigationController = self.navigationController
        newest.couponFeature = .new
        newest.couponCategoryID = self.couponCategoryID
        newest.title = "新着"
        controllerArray.append(newest)
        
        let nearest = ListCouponContentViewController.instanceFromStoryBoard("CouponList") as! ListCouponContentViewController
        nearest.parentNavigationController = self.navigationController
        nearest.couponFeature = .near
        nearest.couponCategoryID = self.couponCategoryID
        nearest.title = "近く"
        controllerArray.append(nearest)
        
        let deal = ListCouponContentViewController.instanceFromStoryBoard("CouponList") as! ListCouponContentViewController
        deal.parentNavigationController = self.navigationController
        deal.couponFeature = .deal
        deal.couponCategoryID = self.couponCategoryID
        deal.title = "お得"
        controllerArray.append(deal)
        
        let parameters: [CAPSPageMenuOption] = [
            .menuItemSeparatorWidth(4.3),
            .scrollMenuBackgroundColor(UIColor.white),
            .viewBackgroundColor(UIColor(hex: DefaultBackgroundColor)),
            .bottomMenuHairlineColor(UIColor(hex: 0xe1e3e5)),
            .selectionIndicatorColor(UIColor(hex: 0x18c0d4)),
            .menuItemWidth(70.0),
            .menuHeight(self.view.bounds.size.height * (50/667)),
            .selectedMenuItemLabelColor(UIColor(hex: 0x29c9c9)),
            .unselectedMenuItemLabelColor(UIColor(hex: 0xa9e9e9)),
            .selectedMenuItemFont(UIFont.HiraginoSansW6(17)),
            .menuItemSeparatorRoundEdges(true),
            .selectionIndicatorHeight(5.0),
            .menuItemSeparatorPercentageHeight(0.1)
        ]
        
        // Initialize scroll menu
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height), pageMenuOptions: parameters)
        pageMenu!.delegate = self
        self.view.addSubview(pageMenu!.view)
    }
    
}

extension ListCouponViewController: CAPSPageMenuDelegate {
    
    func didMoveToPage(_ controller: UIViewController, index: Int) {
    
    }
    
    func willMoveToPage(_ controller: UIViewController, index: Int) {

    }
    
}
