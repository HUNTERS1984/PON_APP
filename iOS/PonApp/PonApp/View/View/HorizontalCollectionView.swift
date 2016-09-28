//
//  HorizontalCollectionView.swift
//  PonApp
//
//  Created by HaoLe on 9/27/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

protocol HorizontalCollectionViewDelegate: class {
    
    func horizontalCollectionView(collectionView: HorizontalCollectionView, didSelectCoupon coupon: Coupon?, atIndexPath indexPath: NSIndexPath)
}

class HorizontalCollectionView: UICollectionView {
    var index: Int!
    weak var handler: HorizontalCollectionViewDelegate? = nil
    var previousSelectedIndexPath: NSIndexPath? = nil
    
    var coupons = [Coupon]() {
        didSet {
            self.reloadData()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.initialize()
    }
    
    func initialize() {
        self.dataSource = self
        self.delegate = self
    }
    
    func resetCollectionView() {
        if let _ = self.previousSelectedIndexPath {
            self.coupons[self.previousSelectedIndexPath!.item].showConfirmView = false
            self.reloadItemsAtIndexPaths([self.previousSelectedIndexPath!])
            self.previousSelectedIndexPath = nil
        }
    }

}

// MARK: - UICollectionViewDataSource
extension HorizontalCollectionView: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.coupons.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CouponCollectionViewCell", forIndexPath: indexPath) as! CouponCollectionViewCell
        cell.coupon = self.coupons[indexPath.item]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let commentView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "CouponCollectionViewCell", forIndexPath: indexPath) as! CouponCollectionViewCell
        return commentView
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenHeight = UIScreen.mainScreen().bounds.height
        let screenWidth = UIScreen.mainScreen().bounds.width
        let width = screenWidth * (162/375)
        let height = screenHeight * (172/667)
        return CGSizeMake(width, height)
    }
    
}

// MARK: - UICollectionViewDelegate
extension HorizontalCollectionView: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedCoupon = self.coupons[indexPath.item]
        if let _ = selectedCoupon.canUse {
            if selectedCoupon.canUse! {
                self.resetCollectionView()
                self.handler?.horizontalCollectionView(self, didSelectCoupon: selectedCoupon, atIndexPath: indexPath)
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
                self.handler?.horizontalCollectionView(self, didSelectCoupon: nil, atIndexPath: indexPath)
            }
        }
    }
    
}