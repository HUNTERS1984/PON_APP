//
//  ShopViewController.swift
//  PonApp
//
//  Created by HaoLe on 9/12/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

let NavBarChangePoint: CGFloat = 50.0

class ShopViewController: BaseViewController {

    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var albumCollectionView: AlbumCollectionView!
    @IBOutlet weak var albumCollectionViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var couponCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.scrollViewDidScroll(self.mainScrollView)
        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.lt_reset()
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor.clearColor())
        self.showBackButton()
        self.phoneButton.setImage(UIImage(named: "shop_detail_button_phone"), forState: .Normal)
        self.locationButton.setImage(UIImage(named: "shop_detail_button_location"), forState: .Normal)
        self.shareButton.setImage(UIImage(named: "shop_detail_button_share"), forState: .Normal)
        
        let myCellNib = UINib(nibName: "CouponCollectionViewCell", bundle: nil)
        couponCollectionView.registerNib(myCellNib, forCellWithReuseIdentifier: "CouponCollectionViewCell")
        self.setupPhotoCollectionView()
    }

}

//MARK: - IBAction
extension ShopViewController {
    
    @IBAction func phoneButtonPressed(sender: AnyObject) {
        
    }
    
    @IBAction func locationButtonPressed(sender: AnyObject) {
        
    }
    
    @IBAction func shareButtonPressed(sender: AnyObject) {
    
    }
    
}

//MARK: - Private
extension ShopViewController {
    
    private func setupPhotoCollectionView() {
        self.albumCollectionView.photos = [
            "https://media.foody.vn/res/g10/93336/s170x170/foody-5ku-quan-nguyen-thong-653-636038386342807622.jpg",
            "https://media.foody.vn/res/g10/93336/s170x170/foody-5ku-quan-nguyen-thong-652-636038386296710231.jpg",
            "https://media.foody.vn/res/g10/93336/s170x170/foody-5ku-quan-nguyen-thong-815-636038386334056950.jpg",
            "https://media.foody.vn/res/g10/93336/s170x170/foody-5ku-quan-nguyen-thong-653-636038386342807622.jpg",
            "https://media.foody.vn/res/g10/93336/s170x170/foody-5ku-quan-nguyen-thong-652-636038386296710231.jpg",
            "https://media.foody.vn/res/g10/93336/s170x170/foody-5ku-quan-nguyen-thong-815-636038386334056950.jpg",
            "https://media.foody.vn/res/g10/93336/s170x170/foody-5ku-quan-nguyen-thong-653-636038386342807622.jpg",
            "https://media.foody.vn/res/g10/93336/s170x170/foody-5ku-quan-nguyen-thong-652-636038386296710231.jpg",
            "https://media.foody.vn/res/g10/93336/s170x170/foody-5ku-quan-nguyen-thong-815-636038386334056950.jpg",
            "https://media.foody.vn/res/g10/93336/s170x170/foody-5ku-quan-nguyen-thong-653-636038386342807622.jpg",
            "https://media.foody.vn/res/g10/93336/s170x170/foody-5ku-quan-nguyen-thong-652-636038386296710231.jpg",
            "https://media.foody.vn/res/g10/93336/s170x170/foody-5ku-quan-nguyen-thong-815-636038386334056950.jpg",
            "https://media.foody.vn/res/g10/93336/s170x170/foody-5ku-quan-nguyen-thong-653-636038386342807622.jpg",
            "https://media.foody.vn/res/g10/93336/s170x170/foody-5ku-quan-nguyen-thong-652-636038386296710231.jpg",
            "https://media.foody.vn/res/g10/93336/s170x170/foody-5ku-quan-nguyen-thong-815-636038386334056950.jpg",
            "https://media.foody.vn/res/g10/93336/s170x170/foody-5ku-quan-nguyen-thong-653-636038386342807622.jpg",
            "https://media.foody.vn/res/g10/93336/s170x170/foody-5ku-quan-nguyen-thong-652-636038386296710231.jpg",
            "https://media.foody.vn/res/g10/93336/s170x170/foody-5ku-quan-nguyen-thong-815-636038386334056950.jpg"
        ]
        self.albumCollectionView.reloadData {
            self.albumCollectionViewConstraint.constant = self.albumCollectionView.contentSize.height
            self.view.layoutIfNeeded()
        }
    }
    
}

//MARK: - UIScrollViewDelegate
extension ShopViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let color = UIColor(hex: 0x18c0d3)
        let offsetY = scrollView.contentOffset.y
        if offsetY > NavBarChangePoint {
            let alpha = min(1, 1 - ((NavBarChangePoint + 64 - offsetY) / 64))
            self.navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(alpha))
        }else {
            self.navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(0))
        }
    }
    
}

//MARK: - UICollectionViewDataSource
extension ShopViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CouponCollectionViewCell", forIndexPath: indexPath) as! CouponCollectionViewCell
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
extension ShopViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let vc = CouponViewController.instanceFromStoryBoard("Coupon")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
