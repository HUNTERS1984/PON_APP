//
//  FavoriteViewController.swift
//  PonApp
//
//  Created by OSXVN on 9/2/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class FavoriteViewController: BaseViewController {

    @IBOutlet weak var tabFavoriteButton: UIButton!
    @IBOutlet weak var tabPonButton: UIButton!
    @IBOutlet weak var tabAccountButton: UIButton!
    @IBOutlet weak var collectionView:UICollectionView!
    
    var coupons = [Coupon]()
    var previousSelectedIndexPath: NSIndexPath? = nil
    
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
        self.title = "お気に入り"
        
        let button = UIBarButtonItem(image: UIImage(named: "nav_add"), style: .Plain, target: self, action: #selector(self.navAddButtonPressed(_: )))
        self.navigationItem.leftBarButtonItem = button
        self.tabFavoriteButton.setImage(UIImage(named: "tabbar_favorite_selected"), forState: .Normal)
        self.tabPonButton.setImage(UIImage(named: "tabbar_pon"), forState: .Normal)
        self.tabAccountButton.setImage(UIImage(named: "tabbar_account_normal"), forState: .Normal)
        
        let myCellNib = UINib(nibName: "CouponCollectionViewCell", bundle: nil)
        collectionView.registerNib(myCellNib, forCellWithReuseIdentifier: "CouponCollectionViewCell")
        
        self.loadFavoriteCoupon(1)
    }
    
    override func setUpComponentsOnWillAppear() {
        super.setUpComponentsOnWillAppear()
    }
    
}

//MARK: - IBAction
extension FavoriteViewController {
    
    @IBAction func favoriteButtonPressed(sender: AnyObject) {
    }
    
    @IBAction func homeButtonPressed(sender: AnyObject) {
        self.tabBarController?.selectedIndex = 1
    }
    
    @IBAction func accountButtonPressed(sender: AnyObject) {
        self.tabBarController?.selectedIndex = 2
    }
    
    @IBAction func navAddButtonPressed(sender: AnyObject) {
//        let vc = ShopViewController.instanceFromStoryBoard("Shop")
//        self.navigationController?.pushViewController(vc, animated: false)
    }
    
}

//MARK: - Private
extension FavoriteViewController {
    
    private func loadFavoriteCoupon(pageIndex: Int) {
        self.showHUD()
        ApiRequest.getFavoriteCoupon(pageIndex: pageIndex) {(request: NSURLRequest?, result: ApiResponse?, error: NSError?) in
            self.hideHUD()
            if let _ = error {
                
            }else {
                var responseCoupon = [Coupon]()
                let couponsArray = result?.data?.array
                if let _ = couponsArray {
                    for couponData in couponsArray! {
                        let coupon = Coupon(response: couponData)
                        responseCoupon.append(coupon)
                    }
                    if pageIndex == 1 {
                        self.displayCoupon(responseCoupon, type: .New)
                    }else {
                        self.displayCoupon(responseCoupon, type: .LoadMore)
                    }
                }
            }
        }
    }
    
    private func displayCoupon(coupons: [Coupon], type: GetType) {
        switch type {
        case .New:
            self.coupons.removeAll()
            self.coupons = coupons
            self.collectionView.reloadData()
            break
        case .LoadMore:
            self.coupons.appendContentsOf(coupons)
            self.collectionView.reloadData()
            break
        case .Reload:
            break
        }
    }
    
    private func getCouponDetail(couponId: Float) {
        self.showHUD()
        ApiRequest.getCouponDetail(couponId) { (request: NSURLRequest?, result: ApiResponse?, error: NSError?) in
            self.hideHUD()
            if let _ = error {
                
            }else {
                let coupon = Coupon(response: result?.data)
                let vc = CouponViewController.instanceFromStoryBoard("Coupon") as! CouponViewController
                vc.coupon = coupon
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    private func resetCollectionView() {
        if let _ = self.previousSelectedIndexPath {
            self.coupons[self.previousSelectedIndexPath!.item].showConfirmView = false
            collectionView.reloadItemsAtIndexPaths([self.previousSelectedIndexPath!])
            self.previousSelectedIndexPath = nil
        }
    }
    
}

//MARK: - UICollectionViewDataSource
extension FavoriteViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coupons.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CouponCollectionViewCell", forIndexPath: indexPath) as! CouponCollectionViewCell
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.mainScreen().scale
        let couponTest = self.coupons[indexPath.item]
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            dispatch_async(dispatch_get_main_queue(), { 
                cell.coupon = couponTest
            })
        }
        return cell
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let commentView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "CouponCollectionViewCell", forIndexPath: indexPath) as! CouponCollectionViewCell
        return commentView
    }
    
}

//MARK: - UICollectionViewDelegate
extension FavoriteViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedCoupon = self.coupons[indexPath.item]
        if let _ = selectedCoupon.canUse {
            if selectedCoupon.canUse! {
                self.resetCollectionView()
                self.getCouponDetail(selectedCoupon.couponID)
            }else {
                if let _ = self.previousSelectedIndexPath {
                    if indexPath == self.previousSelectedIndexPath! {
                        return
                    } 
                    self.coupons[self.previousSelectedIndexPath!.item].showConfirmView = false
                    collectionView.reloadItemsAtIndexPaths([self.previousSelectedIndexPath!])
                    
                    self.coupons[indexPath.item].showConfirmView = true
                    collectionView.reloadItemsAtIndexPaths([indexPath])
                    self.previousSelectedIndexPath = indexPath
                }else {
                    self.coupons[indexPath.item].showConfirmView = true
                    collectionView.reloadItemsAtIndexPaths([indexPath])
                    self.previousSelectedIndexPath = indexPath
                }
            }
        }
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension FavoriteViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenHeight = UIScreen.mainScreen().bounds.height
        let width = (self.view.frame.size.width - 30) / 2.0
        let height = screenHeight * (189/667)
        return CGSizeMake(width, height)
    }
    
}