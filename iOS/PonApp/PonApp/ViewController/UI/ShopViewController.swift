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

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var albumCollectionView: AlbumCollectionView!
    @IBOutlet weak var albumCollectionViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var couponCollectionView: UICollectionView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var shopId: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var accessLabel: UILabel!
    @IBOutlet weak var industriTime: UILabel!
    @IBOutlet weak var holidayLabel: UILabel!
    @IBOutlet weak var meanCountLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!

    var shopCoupon = [Coupon]() {
        didSet {
            self.couponCollectionView.reloadData()
        }
    }
    
    var shop: Shop? = nil
    var previousSelectedIndexPath: NSIndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        self.showBackButton()
        self.view.bringSubviewToFront(self.navigationView)
        self.navigationView.backgroundColor = UIColor(hex: 0x18c0d4).colorWithAlphaComponent(0)
        self.navTitleLabel.alpha = 0
        
        self.backButton.setImage(UIImage(named: "nav_back"), forState: .Normal)
        self.phoneButton.setImage(UIImage(named: "shop_detail_button_phone"), forState: .Normal)
        self.locationButton.setImage(UIImage(named: "shop_detail_button_location"), forState: .Normal)
        self.shareButton.setImage(UIImage(named: "shop_detail_button_share"), forState: .Normal)
        
        let myCellNib = UINib(nibName: "CouponCollectionViewCell", bundle: nil)
        couponCollectionView.registerNib(myCellNib, forCellWithReuseIdentifier: "CouponCollectionViewCell")
        if let _ = self.shop {
            self.displayShopDetail(self.shop!)
        }
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
    
    @IBAction override func backButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}

//MARK: - Private
extension ShopViewController {
    
    private func displayShopDetail(shop: Shop) {
        self.shopNameLabel.text = shop.title
        self.navTitleLabel.text = shop.title
        shopId.text = "\(shop.shopID)"
        addressLabel.text = shop.shopAddress
        accessLabel.text = shop.shopDirection
        industriTime.text = "\(shop.shopStartTime)~\(shop.shopEndTime)"
        holidayLabel.text = shop.regularHoliday
        meanCountLabel.text = "~\(shop.shopAvegerBill)円"
        phoneNumberLabel.text = shop.shopPhonenumber
        self.shopCoupon = shop.shopCoupons
        self.setupPhotoCollectionView(shop.shopPhotosUrl)
    }
    
    private func setupPhotoCollectionView(urls: [String]) {
        self.albumCollectionView.photos = urls
        self.albumCollectionView.reloadData {
            self.albumCollectionViewConstraint.constant = self.albumCollectionView.contentSize.height
            self.view.layoutIfNeeded()
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

//MARK: - UIScrollViewDelegate
extension ShopViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.isKindOfClass(UICollectionView.classForCoder()) {
            return
        }else {
            let color = UIColor(hex: 0x18c0d4)
            let offsetY = scrollView.contentOffset.y
            if offsetY > NavBarChangePoint {
                let alpha = min(1, 1 - ((NavBarChangePoint + 64 - offsetY) / 64))
                self.navigationView.backgroundColor = color.colorWithAlphaComponent(alpha)
                self.navTitleLabel.alpha = alpha
            }else {
                self.navigationView.backgroundColor = color.colorWithAlphaComponent(0)
                self.navTitleLabel.alpha = 0
            }
        }
    }
    
}

//MARK: - UICollectionViewDataSource
extension ShopViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.shopCoupon.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CouponCollectionViewCell", forIndexPath: indexPath) as! CouponCollectionViewCell
        cell.coupon = self.shopCoupon[indexPath.item]
        return cell
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
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

//MARK: - UICollectionViewDelegate
extension ShopViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedCoupon = self.shopCoupon[indexPath.item]
        if let _ = selectedCoupon.canUse {
            if selectedCoupon.canUse! {
                self.getCouponDetail(selectedCoupon.couponID)
            }else {
                if let _ = self.previousSelectedIndexPath {
                    self.shopCoupon[self.previousSelectedIndexPath!.item].showConfirmView = false
                    collectionView.reloadItemsAtIndexPaths([self.previousSelectedIndexPath!])
                    
                    self.shopCoupon[indexPath.item].showConfirmView = true
                    collectionView.reloadItemsAtIndexPaths([indexPath])
                    self.previousSelectedIndexPath = indexPath
                }else {
                    self.shopCoupon[indexPath.item].showConfirmView = true
                    collectionView.reloadItemsAtIndexPaths([indexPath])
                    self.previousSelectedIndexPath = indexPath
                }
            }
        }
    }
    
}
