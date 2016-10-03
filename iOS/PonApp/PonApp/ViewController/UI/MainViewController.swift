//
//  MainViewController.swift
//  PonApp
//
//  Created by OSXVN on 9/2/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class MainViewController: BaseViewController {

    var pageMenu : CAPSPageMenu?
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var seachContainerView: UIView!
    @IBOutlet weak var scrollMenuView: UIView!
    @IBOutlet weak var tabFavoriteButton: UIButton!
    @IBOutlet weak var tabPonButton: UIButton!
    @IBOutlet weak var tabAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        self.setupScrollMenu()
        self.addButton.setImage(UIImage(named: "top_button_add"), forState: .Normal)
        self.locationButton.setImage(UIImage(named: "top_button_location"), forState: .Normal)
        self.tabFavoriteButton.setImage(UIImage(named: "tabbar_favorite_normal"), forState: .Normal)
        self.tabPonButton.setImage(UIImage(named: "tabbar_pon"), forState: .Normal)
        self.tabAccountButton.setImage(UIImage(named: "tabbar_account_normal"), forState: .Normal)
        self.searchTextField.attributedPlaceholder = NSAttributedString(string:"地名/ショップ名を入力", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        self.setupTabbar()
    }
    
}

//MARK: - IBAction
extension MainViewController {
    
    @IBAction func favoriteButtonPressed(sender: AnyObject) {
        if UserDataManager.isLoggedIn() {
            self.tabBarController?.selectedIndex = 0
        }else {
            HLKAlertView.show("Warning", message:UserNotLoggedIn, cancelButtonTitle: "OK", otherButtonTitles: nil, handler: nil)
        }
    }
    
    @IBAction func homeButtonPressed(sender: AnyObject) {
        
    }
    
    @IBAction func accountButtonPressed(sender: AnyObject) {
        if UserDataManager.isLoggedIn() {
            self.tabBarController?.selectedIndex = 2
        }else {
            HLKAlertView.show("Warning", message:UserNotLoggedIn, cancelButtonTitle: "OK", otherButtonTitles: nil, handler: nil)
        }
    }
    
    @IBAction func locationButtonPressed(sender: AnyObject) {
        let vc = HomeSearchViewController.instanceFromStoryBoard("MainMenu")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func addButtonPressed(sender: AnyObject) {
        let vc = AddShopViewController.instanceFromStoryBoard("MainMenu") as! AddShopViewController
        vc.couponType = 1
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - Private methods
extension MainViewController {
    
    internal func setupScrollMenu() {
        var controllerArray : [UIViewController] = []
        
        let popular = MainCouponContentViewController.instanceFromStoryBoard("MainMenu") as! MainCouponContentViewController
        popular.parentNavigationController = self.navigationController
        popular.couponFeature = .Popularity
        popular.title = "人気"
        controllerArray.append(popular)
        
        let newest = MainCouponContentViewController.instanceFromStoryBoard("MainMenu") as! MainCouponContentViewController
        newest.parentNavigationController = self.navigationController
        newest.couponFeature = .New
        newest.title = "新着"
        controllerArray.append(newest)
        
        let nearby = MainCouponContentViewController.instanceFromStoryBoard("MainMenu") as! MainCouponContentViewController
        nearby.parentNavigationController = self.navigationController
        nearby.couponFeature = .Near
        nearby.title = "近く"
        controllerArray.append(nearby)
        
        let deal = MainCouponContentViewController.instanceFromStoryBoard("MainMenu") as! MainCouponContentViewController
        deal.parentNavigationController = self.navigationController
        deal.couponFeature = .Deal
        deal.title = "お得"
        controllerArray.append(deal)
        
        let parameters: [CAPSPageMenuOption] = [
            .MenuItemSeparatorWidth(4.3),
            .ScrollMenuBackgroundColor(UIColor.whiteColor()),
            .ViewBackgroundColor(UIColor(hex: 0xf8f8fa)),
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
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, self.scrollMenuView.frame.width, self.scrollMenuView.frame.height), pageMenuOptions: parameters)
        pageMenu!.delegate = self
        self.scrollMenuView.addSubview(pageMenu!.view)
    }
    
    private func setupTabbar() {
        if UserDataManager.isLoggedIn() {
            self.tabFavoriteButton.hidden = false
            self.tabAccountButton.hidden = false
        }else {
            self.tabFavoriteButton.hidden = true
            self.tabAccountButton.hidden = true
        }
    }
    
}

extension MainViewController: CAPSPageMenuDelegate {
    
    func didMoveToPage(controller: UIViewController, index: Int) {
        
    }
    
    func willMoveToPage(controller: UIViewController, index: Int) {
        
    }
    
}
