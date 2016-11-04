 //
//  HorizontalCollectionView.swift
//  PonApp
//
//  Created by HaoLe on 9/27/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

protocol HorizontalCollectionViewDelegate: class {
    
    func horizontalCollectionView(_ collectionView: HorizontalCollectionView, didSelectCouponAtIndex index: Int, inRowIndex rowIndex:Int)
    func horizontalCollectionView(_ collectionView: HorizontalCollectionView, didPressSignUpButton button: AnyObject?)
}

class HorizontalCollectionView: UICollectionView {
    var rowIndex: Int!
    weak var handler: HorizontalCollectionViewDelegate? = nil
    var previousSelectedIndexPath: IndexPath? = nil
    
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
        let myCellNib = UINib(nibName: "CouponCollectionViewCell", bundle: nil)
        self.register(myCellNib, forCellWithReuseIdentifier: "CouponCollectionViewCell")
    }
    
    func resetCollectionView() {
        if let _ = self.previousSelectedIndexPath {
            self.coupons[self.previousSelectedIndexPath!.item].showConfirmView = false
            self.reloadItems(at: [self.previousSelectedIndexPath!])
            self.previousSelectedIndexPath = nil
        }
    }

}

// MARK: - UICollectionViewDataSource
extension HorizontalCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.coupons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CouponCollectionViewCell", for: indexPath) as! CouponCollectionViewCell
        cell.coupon = self.coupons[indexPath.item]
        cell.completionHandler = { [weak self] in
            self?.handler?.horizontalCollectionView(self!, didPressSignUpButton: nil)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let commentView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CouponCollectionViewCell", for: indexPath) as! CouponCollectionViewCell
        return commentView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        let width = screenWidth * (164/375)
        let height = screenHeight * (175/667)
        return CGSize(width: width, height: height)
    }
    
}

// MARK: - UICollectionViewDelegate
extension HorizontalCollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCoupon = self.coupons[indexPath.item]
        if let _ = selectedCoupon.needLogin {
            if selectedCoupon.needLogin! {
                if UserDataManager.isLoggedIn() {
                    self.resetCollectionView()
                    self.handler?.horizontalCollectionView(self, didSelectCouponAtIndex: indexPath.item, inRowIndex: self.rowIndex)
                }else {
                    if let _ = self.previousSelectedIndexPath {
                        if indexPath == self.previousSelectedIndexPath! {
                            return
                        }
                        self.coupons[self.previousSelectedIndexPath!.item].showConfirmView = false
                        collectionView.reloadItems(at: [self.previousSelectedIndexPath!])
                        
                        self.coupons[indexPath.item].showConfirmView = true
                        collectionView.reloadItems(at: [indexPath])
                        self.previousSelectedIndexPath = indexPath
                    }else {
                        self.coupons[indexPath.item].showConfirmView = true
                        collectionView.reloadItems(at: [indexPath])
                        self.previousSelectedIndexPath = indexPath
                    }
                }
            }else {
                self.resetCollectionView()
                self.handler?.horizontalCollectionView(self, didSelectCouponAtIndex: indexPath.item, inRowIndex: self.rowIndex)
            }
        }
    }
    
}
