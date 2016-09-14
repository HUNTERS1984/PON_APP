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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setupScrollMenu()
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        self.title = "グルメ"
        self.showBackButton()
        let barButton = UIBarButtonItem(image: UIImage(named: "nav_search"), style: .Plain, target: self, action: #selector(self.searchBarButtonPressed(_:)))
        self.navigationItem.rightBarButtonItem = barButton
    }
}

//IBAction
extension ListCouponViewController {
    
    @IBAction func searchBarButtonPressed(sender: AnyObject) {
        
    }
    
}

extension ListCouponViewController {
    
    internal func setupScrollMenu() {
        var controllerArray : [UIViewController] = []
        
        let popular = CouponPopularViewController.instanceFromStoryBoard("CouponList") as! CouponPopularViewController
        popular.parentNavigationController = self.navigationController
        popular.title = "人気"
        controllerArray.append(popular)
        
        let newest = CouponNewestViewController.instanceFromStoryBoard("CouponList") as! CouponNewestViewController
        newest.parentNavigationController = self.navigationController
        newest.title = "新着"
        controllerArray.append(newest)
        
        let nearest = CouponNearestViewController.instanceFromStoryBoard("CouponList") as! CouponNearestViewController
        nearest.parentNavigationController = self.navigationController
        nearest.title = "近く"
        controllerArray.append(nearest)
        
        let parameters: [CAPSPageMenuOption] = [
            .MenuItemSeparatorWidth(4.3),
            .ScrollMenuBackgroundColor(UIColor.whiteColor()),
            .ViewBackgroundColor(UIColor.whiteColor()),
            .BottomMenuHairlineColor(UIColor(hex: 0xe1e3e5)),
            .SelectionIndicatorColor(UIColor(hex: 0x18c0d4)),
            .MenuItemWidth(70.0),
            .MenuHeight(50.0),
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
        print("did move to page")
    }
    
    func willMoveToPage(controller: UIViewController, index: Int) {
        print("will move to page")
    }
    
}