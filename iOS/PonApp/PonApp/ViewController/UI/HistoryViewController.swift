//
//  HistoryViewController.swift
//  PonApp
//
//  Created by HaoLe on 9/27/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class HistoryViewController: BaseViewController {

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
        self.title = "履歴 12"
        self.showBackButton()
        
        let myCellNib = UINib(nibName: "CouponCollectionViewCell", bundle: nil)
        collectionView.registerNib(myCellNib, forCellWithReuseIdentifier: "CouponCollectionViewCell")
        
        self.loadUsedCoupon(1)
    }
    
    override func setUpComponentsOnWillAppear() {
        super.setUpComponentsOnWillAppear()
    }
    
}

//MARK: - IBAction
extension HistoryViewController {
    
}

//MARK: - Private
extension HistoryViewController {
    
    private func loadUsedCoupon(pageIndex: Int) {
        self.showHUD()
        ApiRequest.getUsedCoupon(pageIndex: pageIndex) {(request: NSURLRequest?, result: ApiResponse?, error: NSError?) in
            self.hideHUD()
            if let _ = error {
                
            }else {
                var responseCoupon = [Coupon]()
                let couponsArray = result?.data?.array
                if let _ = couponsArray {
                    for couponData in couponsArray! {
                        var coupon = Coupon(response: couponData)
                        coupon.isUsed = true
                        responseCoupon.append(coupon)
                    }
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
    
}

//MARK: - UICollectionViewDataSource
extension HistoryViewController: UICollectionViewDataSource {
    
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
extension HistoryViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedCoupon = self.coupons[indexPath.item]
        self.getCouponDetail(selectedCoupon.couponID)
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension HistoryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenHeight = UIScreen.mainScreen().bounds.height
        let width = (self.view.frame.size.width - 30) / 2.0
        let height = screenHeight * (189/667)
        return CGSizeMake(width, height)
    }
    
}
