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
        self.title = "フォロー 12"
        self.showBackButton()
        
        let myCellNib = UINib(nibName: "ShopFollowCollectionViewCell", bundle: nil)
        collectionView.registerNib(myCellNib, forCellWithReuseIdentifier: "ShopFollowCollectionViewCell")
        self.loadFollowedShop(1)
    }
    
}


//MARK: - Private
extension ShopFollowViewController {
    
    private func loadFollowedShop(pageIndex: Int) {
        self.showHUD()
        ApiRequest.getFollowedShop(pageIndex: pageIndex) {(request: NSURLRequest?, result: ApiResponse?, error: NSError?) in
            self.hideHUD()
            if let _ = error {
                
            }else {
                var responseShop = [Shop]()
                let shopArray = result?.data?.array
                if let _ = shopArray {
                    for shopData in shopArray! {
                        let shop = Shop(response: shopData)
                        responseShop.append(shop)
                    }
                    if pageIndex == 1 {
                        self.displayShop(responseShop, type: .New)
                    }else {
                        self.displayShop(responseShop, type: .LoadMore)
                    }
                }else {
                    
                }
            }
        }
    }
    
    private func displayShop(shops: [Shop], type: GetType) {
        switch type {
        case .New:
            self.shops.removeAll()
            self.shops = shops
            self.collectionView.reloadData()
            break
        case .LoadMore:
            self.shops.appendContentsOf(shops)
            self.collectionView.reloadData()
            break
        case .Reload:
            break
        }
    }
    
    private func getShopDetail(shopId: Float) {
        self.showHUD()
        ApiRequest.getShopDetail(shopId) { (request: NSURLRequest?, result: ApiResponse?, error: NSError?) in
            self.hideHUD()
            if let _ = error {
                
            }else {
                let shop = Shop(response: result?.data)
                let vc = ShopViewController.instanceFromStoryBoard("Shop") as! ShopViewController
                vc.shop = shop
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}

//MARK: - UICollectionViewDataSource
extension ShopFollowViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.shops.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ShopFollowCollectionViewCell", forIndexPath: indexPath) as! ShopFollowCollectionViewCell
        cell.shop = self.shops[indexPath.item]
        return cell
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let commentView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "ListCouponCollectionViewCell", forIndexPath: indexPath) as! ListCouponCollectionViewCell
        return commentView
    }
    
}

//MARK: - UICollectionViewDelegate
extension ShopFollowViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedShopId = self.shops[indexPath.item].shopID
        self.getShopDetail(selectedShopId)
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ShopFollowViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let picDimension = (self.view.frame.size.width - 30) / 2.0
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        return CGSizeMake(picDimension, screenSize.height * (220/667))
    }
    
}