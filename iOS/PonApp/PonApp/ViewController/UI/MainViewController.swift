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
        self.setupScrollMenu()
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
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
    }
}

//MARK: - Private methods
extension MainViewController {
    
    internal func setupScrollMenu() {
        var controllerArray : [UIViewController] = []
        
        let popular = HomePopularViewController.instanceFromStoryBoard("MainMenu") as! HomePopularViewController
        popular.parentNavigationController = self.navigationController
        popular.title = "Popular"
        controllerArray.append(popular)
        
        let nearby = HomeNearByViewController.instanceFromStoryBoard("MainMenu") as! HomeNearByViewController
        nearby.parentNavigationController = self.navigationController
        nearby.title = "Nearest"
        controllerArray.append(nearby)
        
        let used = HomeUsedViewController.instanceFromStoryBoard("MainMenu") as! HomeUsedViewController
        used.parentNavigationController = self.navigationController
        used.title = "Used"
        controllerArray.append(used)
        
        let newest = HomeNewestViewController.instanceFromStoryBoard("MainMenu") as! HomeNewestViewController
        newest.parentNavigationController = self.navigationController
        newest.title = "Newest"
        controllerArray.append(newest)
        
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
            .MenuItemFont(UIFont(name: "HelveticaNeue-Medium", size: 14.0)!),
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
        print("did move to page")
    }
    
    func willMoveToPage(controller: UIViewController, index: Int) {
        print("will move to page")
    }
    
}
