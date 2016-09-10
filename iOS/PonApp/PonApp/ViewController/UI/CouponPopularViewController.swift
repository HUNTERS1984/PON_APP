//
//  CouponPopularViewController.swift
//  PonApp
//
//  Created by HaoLe on 9/8/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class CouponPopularViewController: UIViewController {

    var parentNavigationController : UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK: - UICollectionViewDataSource
extension CouponPopularViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ListCouponCollectionViewCell", forIndexPath: indexPath) as! ListCouponCollectionViewCell
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
extension CouponPopularViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension CouponPopularViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let picDimension = (self.view.frame.size.width - 30) / 2.0
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        return CGSizeMake(picDimension, screenSize.height * (220/667))
    }
    
}