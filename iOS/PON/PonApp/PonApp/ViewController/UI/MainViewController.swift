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
    @IBOutlet weak var buildLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerProcessNotification()
        self.processRemoteNewsNotificationLauchApp()
        self.processRemoteNotificationLauchApp()
        self.buildLabel.text = self.getBuildInfo()
    }
    
    func getBuildInfo() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        return "\(version) build \(build)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func startGoogleAnalytics() {
        super.startGoogleAnalytics()
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: GAScreen_Main)
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
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
        super.setUpComponentsOnWillAppear()
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
        let vc = HomeMenuViewController.instanceFromStoryBoard("MainMenu")
        self.navigationController?.pushViewController(vc!, animated: true)
    }

}

//MARK: - Private methods
extension MainViewController {
    
    internal func setupScrollMenu() {
        var controllerArray : [UIViewController] = []
        
        let popular = MainCouponContentViewController.instanceFromStoryBoard("MainMenu") as! MainCouponContentViewController
        popular.parentNavigationController = self.navigationController
        popular.parentContainerController = self
        popular.couponFeature = .popularity
        popular.title = "人気"
        controllerArray.append(popular)
        
        let newest = MainCouponContentViewController.instanceFromStoryBoard("MainMenu") as! MainCouponContentViewController
        newest.parentNavigationController = self.navigationController
        newest.parentContainerController = self
        newest.couponFeature = .new
        newest.title = "新着"
        controllerArray.append(newest)
        
        let nearby = MainCouponContentViewController.instanceFromStoryBoard("MainMenu") as! MainCouponContentViewController
        nearby.parentNavigationController = self.navigationController
        nearby.parentContainerController = self
        nearby.couponFeature = .near
        nearby.title = "近く"
        controllerArray.append(nearby)
        
        let deal = MainCouponContentViewController.instanceFromStoryBoard("MainMenu") as! MainCouponContentViewController
        deal.parentNavigationController = self.navigationController
        deal.parentContainerController = self
        deal.couponFeature = .deal
        deal.title = "お得"
        controllerArray.append(deal)
        
        let parameters: [CAPSPageMenuOption] = [
            .menuItemSeparatorWidth(4.3),
            .scrollMenuBackgroundColor(UIColor.white),
            .viewBackgroundColor(UIColor(hex: DefaultBackgroundColor)),
            .bottomMenuHairlineColor(UIColor(hex: 0xe1e3e5)),
            .selectionIndicatorColor(UIColor(hex: 0x18c0d4)),
            .menuItemWidth(78.0),
            .menuHeight(self.view.bounds.size.height * (50/667)),
            .selectedMenuItemLabelColor(UIColor(hex: 0x29c9c9)),
            .unselectedMenuItemLabelColor(UIColor(hex: 0xa9e9e9)),
            .selectedMenuItemFont(UIFont.HiraginoSansW6(13)),
            .unselectedMenuItemFont(UIFont.HiraginoSansW3(13)),
            .menuItemSeparatorRoundEdges(true),
            .selectionIndicatorHeight(5.0),
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
    
    fileprivate func seachCoupon(_ searchText: String) {
        self.showHUD()
        ApiRequest.searchCoupon(searchText, pageIndex: 0, hasAuth: UserDataManager.isLoggedIn()) { (request: URLRequest?, result: ApiResponse?, error: NSError?) in
            self.hideHUD()
            if let _ = error {
                
            }else {
                var responseCoupon = [Coupon]()
                let couponsArray = result?.data?.array
                if let _ = couponsArray {
                    if couponsArray!.count > 0 {
                        for couponData in couponsArray! {
                            let coupon = Coupon(response: couponData)
                            responseCoupon.append(coupon)
                        }
                        let vc = SearchResultViewController.instanceFromStoryBoard("Search") as! SearchResultViewController
                        vc.coupons = responseCoupon
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else {
                        self.presentAlert(with: "", message: NoResult)
                    }
                }
            }
        }
    }
    
}

extension MainViewController: CAPSPageMenuDelegate {
    
    func didMoveToPage(_ controller: UIViewController, index: Int) {
        
    }
    
    func willMoveToPage(_ controller: UIViewController, index: Int) {
        
    }
    
}

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .search {
            textField.resignFirstResponder()
            let seachText = textField.text//山岸舞
            if let _ = seachText {
                if seachText!.characters.count > 0 {
                    self.seachCoupon(seachText!)
                }
            }
        }
        return true
    }
}
