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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        self.setupScrollMenu()
        self.addButton.setImage(UIImage(named: "top_button_add"), for: UIControlState())
        self.locationButton.setImage(UIImage(named: "top_button_location"), for: UIControlState())
        self.tabFavoriteButton.setImage(UIImage(named: "tabbar_favorite_normal"), for: UIControlState())
        self.tabPonButton.setImage(UIImage(named: "tabbar_pon"), for: UIControlState())
        self.tabAccountButton.setImage(UIImage(named: "tabbar_account_normal"), for: UIControlState())
        self.searchTextField.attributedPlaceholder = NSAttributedString(string:"地名/ショップ名を入力", attributes:[NSForegroundColorAttributeName: UIColor.white])
        
    }
    
    override func setUpComponentsOnWillAppear() {
        self.setupTabbar()
    }
    
}

//MARK: - IBAction
extension MainViewController {
    
    @IBAction func favoriteButtonPressed(_ sender: AnyObject) {
        if UserDataManager.isLoggedIn() {
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    @IBAction func homeButtonPressed(_ sender: AnyObject) {
        
    }
    
    @IBAction func accountButtonPressed(_ sender: AnyObject) {
        if UserDataManager.isLoggedIn() {
            self.tabBarController?.selectedIndex = 2
        }
    }
    
    @IBAction func locationButtonPressed(_ sender: AnyObject) {
        let vc = HomeSearchViewController.instanceFromStoryBoard("MainMenu")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: AnyObject) {
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
        popular.couponFeature = .popularity
        popular.title = "人気"
        controllerArray.append(popular)
        
        let newest = MainCouponContentViewController.instanceFromStoryBoard("MainMenu") as! MainCouponContentViewController
        newest.parentNavigationController = self.navigationController
        newest.couponFeature = .new
        newest.title = "新着"
        controllerArray.append(newest)
        
        let nearby = MainCouponContentViewController.instanceFromStoryBoard("MainMenu") as! MainCouponContentViewController
        nearby.parentNavigationController = self.navigationController
        nearby.couponFeature = .near
        nearby.title = "近く"
        controllerArray.append(nearby)
        
        let deal = MainCouponContentViewController.instanceFromStoryBoard("MainMenu") as! MainCouponContentViewController
        deal.parentNavigationController = self.navigationController
        deal.couponFeature = .deal
        deal.title = "お得"
        controllerArray.append(deal)
        
        let parameters: [CAPSPageMenuOption] = [
            .menuItemSeparatorWidth(4.3),
            .scrollMenuBackgroundColor(UIColor.white),
            .viewBackgroundColor(UIColor.white),
            .bottomMenuHairlineColor(UIColor(hex: 0xe1e3e5)),
            .selectionIndicatorColor(UIColor(hex: 0x18c0d4)),
            .menuItemWidth(70.0),
            .menuHeight(self.view.bounds.size.height * (50/667)),
            .selectedMenuItemLabelColor(UIColor(hex: 0x29c9c9)),
            .unselectedMenuItemLabelColor(UIColor(hex: 0xa9e9e9)),
            .menuItemFont(UIFont.HiraginoSansW6(17)),
            .menuItemSeparatorRoundEdges(true),
            .selectionIndicatorHeight(2.0),
            .menuItemSeparatorPercentageHeight(0.1)
        ]
        // Initialize scroll menu
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 0.0, width: self.scrollMenuView.frame.width, height: self.scrollMenuView.frame.height), pageMenuOptions: parameters)
        pageMenu!.delegate = self
        self.scrollMenuView.addSubview(pageMenu!.view)
    }
    
    fileprivate func setupTabbar() {
        if UserDataManager.isLoggedIn() {
            self.tabFavoriteButton.isHidden = false
            self.tabAccountButton.isHidden = false
        }else {
            self.tabFavoriteButton.isHidden = true
            self.tabAccountButton.isHidden = true
        }
    }
    
}

extension MainViewController: CAPSPageMenuDelegate {
    
    func didMoveToPage(_ controller: UIViewController, index: Int) {
        
    }
    
    func willMoveToPage(_ controller: UIViewController, index: Int) {
        
    }
    
}
