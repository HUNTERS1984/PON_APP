//
//  ListShopViewController.swift
//  PonApp
//
//  Created by OSXVN on 9/28/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class ListShopViewController: BaseViewController {
    
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
        self.title = "グルメ"
        self.showBackButton()
        let barButton = UIBarButtonItem(image: UIImage(named: "nav_search"), style: .plain, target: self, action: #selector(self.searchBarButtonPressed(_:)))
        self.navigationItem.rightBarButtonItem = barButton
        self.setupScrollMenu()
    }
}

//IBAction
extension ListShopViewController {
    
    @IBAction func searchBarButtonPressed(_ sender: AnyObject) {
        let vc = HomeSearchViewController.instanceFromStoryBoard("MainMenu")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}

extension ListShopViewController {
    
    internal func setupScrollMenu() {
        var controllerArray : [UIViewController] = []
        
        let popular = ListShopContentViewController.instanceFromStoryBoard("ListShop") as! ListShopContentViewController
        popular.parentNavigationController = self.navigationController
        popular.couponFeature = .popularity
        popular.couponCategoryID = self.couponCategoryID
        popular.title = "人気"
        controllerArray.append(popular)
        
        let newest = ListShopContentViewController.instanceFromStoryBoard("ListShop") as! ListShopContentViewController
        newest.parentNavigationController = self.navigationController
        newest.couponFeature = .new
        newest.couponCategoryID = self.couponCategoryID
        newest.title = "新着"
        controllerArray.append(newest)
        
        let nearest = ListShopContentViewController.instanceFromStoryBoard("ListShop") as! ListShopContentViewController
        nearest.parentNavigationController = self.navigationController
        nearest.couponFeature = .near
        nearest.couponCategoryID = self.couponCategoryID
        nearest.title = "近く"
        controllerArray.append(nearest)
        
        let parameters: [CAPSPageMenuOption] = [
            .menuItemSeparatorWidth(4.3),
            .scrollMenuBackgroundColor(UIColor.white),
            .viewBackgroundColor(UIColor.white),
            .bottomMenuHairlineColor(UIColor(hex: 0xe1e3e5)),
            .selectionIndicatorColor(UIColor(hex: 0x18c0d4)),
            .menuItemWidth(78.0),
            .menuHeight(self.view.bounds.size.height * (50/667)),
            .selectedMenuItemLabelColor(UIColor(hex: 0x29c9c9)),
            .unselectedMenuItemLabelColor(UIColor(hex: 0xa9e9e9)),
            .selectedMenuItemFont(UIFont.HiraginoSansW6(13)),
            .unselectedMenuItemFont(UIFont.HiraginoSansW3(13)),
            .menuItemSeparatorRoundEdges(true),
            .selectionIndicatorHeight(2.0),
            .menuItemSeparatorPercentageHeight(0.1)
        ]
        
        // Initialize scroll menu
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height), pageMenuOptions: parameters)
        pageMenu!.delegate = self
        self.view.addSubview(pageMenu!.view)
    }
    
}

extension ListShopViewController: CAPSPageMenuDelegate {
    
    func didMoveToPage(_ controller: UIViewController, index: Int) {

    }
    
    func willMoveToPage(_ controller: UIViewController, index: Int) {

    }
    
}
