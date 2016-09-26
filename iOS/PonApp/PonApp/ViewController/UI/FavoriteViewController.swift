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
        let vc = ShopViewController.instanceFromStoryBoard("Shop")
        self.navigationController?.pushViewController(vc, animated: false)
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
                    self.coupons = responseCoupon
                    if pageIndex == 1 {
                        self.displayCoupon(responseCoupon, type: .New)
                    }else {
                        self.displayCoupon(responseCoupon, type: .LoadMore)
                    }
                }else {
                    
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
    
}

//MARK: - UICollectionViewDataSource
extension FavoriteViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coupons.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CouponCollectionViewCell", forIndexPath: indexPath) as! CouponCollectionViewCell
        let couponTest = self.coupons[indexPath.item]
        cell.coupon = couponTest
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
        var selectedCoupon = self.coupons[indexPath.item]
        if let _ = selectedCoupon.canUse {
            if selectedCoupon.canUse! {
                let vc = CouponViewController.instanceFromStoryBoard("Coupon")
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                selectedCoupon.showConfirmView = true
                self.coupons[indexPath.item] = selectedCoupon
                collectionView.reloadItemsAtIndexPaths([indexPath])
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