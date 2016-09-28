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
    }
    
}

//MARK: - IBAction
extension MainViewController {
    
    @IBAction func favoriteButtonPressed(sender: AnyObject) {
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func homeButtonPressed(sender: AnyObject) {
    }
    
    @IBAction func accountButtonPressed(sender: AnyObject) {
        self.tabBarController?.selectedIndex = 2
    }
    
    @IBAction func locationButtonPressed(sender: AnyObject) {
        let vc = HomeSearchViewController.instanceFromStoryBoard("MainMenu")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func addButtonPressed(sender: AnyObject) {
        let vc = ShopFollowViewController.instanceFromStoryBoard("Follow")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - Private methods
extension MainViewController {
    
    internal func setupScrollMenu() {
        var controllerArray : [UIViewController] = []
        
//        let popular = HomePopularViewController.instanceFromStoryBoard("MainMenu") as! HomePopularViewController
        let popular = HomeNearestViewController.instanceFromStoryBoard("MainMenu") as! HomeNearestViewController
        popular.parentNavigationController = self.navigationController
        popular.title = "人気"
        controllerArray.append(popular)
        
//        let newest = HomeNewestViewController.instanceFromStoryBoard("MainMenu") as! HomeNewestViewController
        let newest = HomeNearestViewController.instanceFromStoryBoard("MainMenu") as! HomeNearestViewController
        newest.parentNavigationController = self.navigationController
        newest.title = "新着"
        controllerArray.append(newest)
        
        let nearby = HomeNearestViewController.instanceFromStoryBoard("MainMenu") as! HomeNearestViewController
        nearby.parentNavigationController = self.navigationController
        nearby.title = "近く"
        controllerArray.append(nearby)
        
//        let used = HomeUsedViewController.instanceFromStoryBoard("MainMenu") as! HomeUsedViewController
        let used = HomeNearestViewController.instanceFromStoryBoard("MainMenu") as! HomeNearestViewController
        used.parentNavigationController = self.navigationController
        used.title = "お得"
        controllerArray.append(used)
        
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
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, self.scrollMenuView.frame.width, self.scrollMenuView.frame.height), pageMenuOptions: parameters)
        pageMenu!.delegate = self
        self.scrollMenuView.addSubview(pageMenu!.view)
    }
    
}

extension MainViewController: CAPSPageMenuDelegate {
    
    func didMoveToPage(controller: UIViewController, index: Int) {
        
    }
    
    func willMoveToPage(controller: UIViewController, index: Int) {
        
    }
    
}
