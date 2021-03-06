//
//  ShopFollowViewController.swift
//  PonApp
//
//  Created by OSXVN on 9/17/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class ShopFollowViewController: BaseViewController {
    
    @IBOutlet weak var collectionView:UICollectionView!
    
    var shops = [Shop]()
    
    //paging
    var canLoadMore: Bool = true
    var currentPage: Int = 1
    var totalPage: Int!
    var nextPage: Int = 1
    
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
    
    override func startGoogleAnalytics() {
        super.startGoogleAnalytics()
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: GAScreen_ProfileFollowShop)
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        self.title = "フォロー \(UserDataManager.shared.shopFollowNumber)"
        self.showBackButton()
        
        let myCellNib = UINib(nibName: "ShopFollowCollectionViewCell", bundle: nil)
        collectionView.register(myCellNib, forCellWithReuseIdentifier: "ShopFollowCollectionViewCell")
        self.loadFollowedShop(1)
    }
    
}


//MARK: - Private
extension ShopFollowViewController {
    
    fileprivate func loadFollowedShop(_ pageIndex: Int) {
        self.showHUD()
        ApiRequest.getFollowedShop(pageIndex: pageIndex) {(request: URLRequest?, result: ApiResponse?, error: NSError?) in
            self.hideHUD()
            if let _ = error {
                
            }else {
                if result?.code == SuccessCode {
                    self.nextPage = result!.nextPage
                    self.totalPage = result!.totalPage
                    self.currentPage = result!.currentPage
                    
                    var responseShop = [Shop]()
                    let shopArray = result?.data?.array
                    if let _ = shopArray {
                        for shopData in shopArray! {
                            let shop = Shop(response: shopData)
                            responseShop.append(shop)
                        }
                        if pageIndex == 1 {
                            self.displayShop(responseShop, type: .new)
                        }else {
                            self.displayShop(responseShop, type: .loadMore)
                        }
                    }
                }else {
                    self.presentAlert(message: (result?.message)!)
                }
            }
        }
    }
    
    fileprivate func displayShop(_ shops: [Shop], type: GetType) {
        switch type {
        case .new:
            self.shops.removeAll()
            self.shops = shops
            self.collectionView.reloadData()
            break
        case .loadMore:
            self.shops.append(contentsOf: shops)
            self.collectionView.reloadData()
            break
        case .reload:
            break
        }
    }
    
    fileprivate func getShopDetail(_ shopId: Float) {
        self.showHUD()
        ApiRequest.getShopDetail(shopId) { (request: URLRequest?, result: ApiResponse?, error: NSError?) in
            self.hideHUD()
            if let _ = error {
                
            }else {
                if result?.code == SuccessCode {
                    let shop = Shop(response: result?.data)
                    let vc = ShopViewController.instanceFromStoryBoard("Shop") as! ShopViewController
                    vc.shop = shop
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    fileprivate func unFollowShop(_ shopId: Float, index: Int) {
        UIAlertController.present(title: "", message: UnFollowShopConfirmation, actionTitles: [OK, Cancel]) { (action) -> () in
            if action.title == "OK" {
                self.showHUD()
                ApiRequest.unFollowShop(shopId) { (request: URLRequest?, result: ApiResponse?, error: NSError?) in
                    self.hideHUD()
                    if let _ = error {
                        
                    }else {
                        if result?.code == SuccessCode {
                            self.shops.remove(at: index)
                            self.collectionView.reloadData()
                            UserDataManager.getUserProfile()
                        }else {
                            self.presentAlert(message: (result?.message)!)
                        }
                    }
                }
            }
        }
    }
    
}

//MARK: - UICollectionViewDataSource
extension ShopFollowViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.shops.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShopFollowCollectionViewCell", for: indexPath) as! ShopFollowCollectionViewCell
        cell.shop = self.shops[(indexPath as NSIndexPath).item]
        cell.index = indexPath.item
        cell.completionHandler = { [weak self] (shopID: Float?, index: Int) in
            if let _ = shopID {
                if UserDataManager.isLoggedIn() {
                    let shop = self?.shops[index]
                    if shop!.isFollow! {
                        self?.unFollowShop(shopID!, index: index)
                    }
                }else {
                    self?.presentAlert(message: UserNotLoggedIn)
                }
            }
        }
        return cell
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let commentView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ListCouponCollectionViewCell", for: indexPath) as! ListCouponCollectionViewCell
        return commentView
    }
    
}

//MARK: - UICollectionViewDelegate
extension ShopFollowViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedShopId = self.shops[(indexPath as NSIndexPath).item].shopID
        self.getShopDetail(selectedShopId!)
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ShopFollowViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = (self.view.frame.size.width - 22) / 2.0
            let screenSize: CGRect = UIScreen.main.bounds
            return CGSize(width: width, height: screenSize.height * (228/667))
    }
    
}

//MARK: - UIScrollViewDelegate
extension ShopFollowViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.currentPage == self.totalPage {
            return
        }
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height && canLoadMore {
            canLoadMore = false
            self.loadFollowedShop(self.nextPage)
        }
    }
    
}
