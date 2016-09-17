//
//  ShopFollowViewController.swift
//  PonApp
//
//  Created by OSXVN on 9/17/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class ShopFollowViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        self.title = "フォロー 12"
        self.showBackButton()
    }
    
}

//MARK: - UICollectionViewDataSource
extension ShopFollowViewController: UICollectionViewDataSource {
    
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
extension ShopFollowViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let vc = ShopViewController.instanceFromStoryBoard("Shop")
        self.navigationController?.pushViewController(vc, animated: false)
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