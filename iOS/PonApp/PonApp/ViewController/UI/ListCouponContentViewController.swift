//
//  ListCouponContentViewController.swift
//  PonApp
//
//  Created by OSXVN on 9/28/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class ListCouponContentViewController: BaseViewController {
    
    @IBOutlet weak var collectionView:UICollectionView!
    
    var parentNavigationController : UINavigationController?
    var couponFeature:CouponFeature?
    var couponType: Int?
    
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
        let myCellNib = UINib(nibName: "CouponCollectionViewCell", bundle: nil)
        collectionView.registerNib(myCellNib, forCellWithReuseIdentifier: "CouponCollectionViewCell")

        self.getCouponByFeatureAndType(1)
    }
    
    override func setUpComponentsOnWillAppear() {
        super.setUpComponentsOnWillAppear()
    }
    
}

//MARK: - IBAction
extension ListCouponContentViewController {
    
}

//MARK: - Private
extension ListCouponContentViewController {
    
    private func getCouponByFeatureAndType(pageIndex: Int) {
        self.showHUD()
        ApiRequest.getCouponByFeatureAndType(self.couponFeature!, couponType: self.couponType!, pageIndex: 1) {(request: NSURLRequest?, result: ApiResponse?, error: NSError?) in
            self.hideHUD()
            if let _ = error {
                
            }else {
                if result?.code == SuccessCode {
                    var responseCoupon = [Coupon]()
                    let couponsArray = result?.data?["coupons"].array
                    let couponType = result?.data?["name"].string
                    if let _ = couponsArray {
                        for couponData in couponsArray! {
                            var coupon = Coupon(response: couponData)
                            coupon.couponType = couponType
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
                self.parentNavigationController?.pushViewController(vc, animated: true)
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
extension ListCouponContentViewController: UICollectionViewDataSource {
    
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
extension ListCouponContentViewController: UICollectionViewDelegate {
    
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
extension ListCouponContentViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenHeight = UIScreen.mainScreen().bounds.height
        let width = (self.view.frame.size.width - 30) / 2.0
        let height = screenHeight * (189/667)
        return CGSizeMake(width, height)
    }
    
}
