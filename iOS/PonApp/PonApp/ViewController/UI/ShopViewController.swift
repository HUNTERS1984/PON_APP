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
    @IBOutlet weak var detailMapView: MapView!

    var shopCoupon = [Coupon]() {
        didSet {
            self.couponCollectionView.reloadData()
        }
    }
    
    var shop: Shop? = nil
    var previousSelectedIndexPath: IndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        self.showBackButton()
        self.view.bringSubview(toFront: self.navigationView)
        self.navigationView.backgroundColor = UIColor(hex: 0x18c0d4).withAlphaComponent(0)
        self.navTitleLabel.alpha = 0
        
        self.backButton.setImage(UIImage(named: "nav_back"), for: UIControlState())
        self.phoneButton.setImage(UIImage(named: "shop_detail_button_phone"), for: UIControlState())
        self.locationButton.setImage(UIImage(named: "shop_detail_button_location"), for: UIControlState())
        self.shareButton.setImage(UIImage(named: "shop_detail_button_share"), for: UIControlState())
        
        let myCellNib = UINib(nibName: "CouponCollectionViewCell", bundle: nil)
        couponCollectionView.register(myCellNib, forCellWithReuseIdentifier: "CouponCollectionViewCell")
        if let _ = self.shop {
            self.displayShopDetail(self.shop!)
        }
    }

}

//MARK: - IBAction
extension ShopViewController {
    
    @IBAction func phoneButtonPressed(_ sender: AnyObject) {
        
    }
    
    @IBAction func locationButtonPressed(_ sender: AnyObject) {
        
    }
    
    @IBAction func shareButtonPressed(_ sender: AnyObject) {
    
    }
    
    @IBAction override func backButtonPressed(_ sender: AnyObject) {
        self.navigationController!.popViewController(animated: true)
    }
    
}

//MARK: - Private
extension ShopViewController {
    
    fileprivate func displayShopDetail(_ shop: Shop) {
        self.shopNameLabel.text = shop.title
        self.navTitleLabel.text = shop.title
        shopId.text = "\(shop.shopID!)"
        addressLabel.text = shop.shopAddress
        accessLabel.text = shop.shopDirection
        industriTime.text = "\(shop.shopStartTime!)~\(shop.shopEndTime!)"
        holidayLabel.text = shop.regularHoliday
        meanCountLabel.text = "~\(shop.shopAvegerBill!)円"
        phoneNumberLabel.text = shop.shopPhonenumber
        self.shopCoupon = shop.shopCoupons
        self.setupPhotoCollectionView(shop.shopPhotosUrl)
        self.detailMapView.createShopMarker(shop.coordinate)
    }
    
    fileprivate func setupPhotoCollectionView(_ urls: [String]) {
        self.albumCollectionView.photos = urls
        self.albumCollectionView.reloadData {
            self.albumCollectionViewConstraint.constant = self.albumCollectionView.contentSize.height
            self.view.layoutIfNeeded()
        }
    }
    
    fileprivate func getCouponDetail(_ couponId: Float) {
        self.showHUD()
        ApiRequest.getCouponDetail(couponId, hasAuth: UserDataManager.isLoggedIn()) { (request: URLRequest?, result: ApiResponse?, error: NSError?) in
            self.hideHUD()
            if let _ = error {
                
            }else {
                if result?.code == SuccessCode {
                    let coupon = Coupon(response: result?.data)
                    let vc = CouponViewController.instanceFromStoryBoard("Coupon") as! CouponViewController
                    vc.coupon = coupon
                    self.navigationController!.pushViewController(vc, animated: true)
                }else {
                    self.presentAlert(message: (result?.message)!)
                }
            }
        }
    }
    
}

//MARK: - UIScrollViewDelegate
extension ShopViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isKind(of: UICollectionView.classForCoder()) {
            return
        }else {
            let color = UIColor(hex: 0x18c0d4)
            let offsetY = scrollView.contentOffset.y
            if offsetY > NavBarChangePoint {
                let alpha = min(1, 1 - ((NavBarChangePoint + 64 - offsetY) / 64))
                self.navigationView.backgroundColor = color.withAlphaComponent(alpha)
                self.navTitleLabel.alpha = alpha
            }else {
                self.navigationView.backgroundColor = color.withAlphaComponent(0)
                self.navTitleLabel.alpha = 0
            }
        }
    }
    
}

//MARK: - UICollectionViewDataSource
extension ShopViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.shopCoupon.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CouponCollectionViewCell", for: indexPath) as! CouponCollectionViewCell
        cell.coupon = self.shopCoupon[(indexPath as NSIndexPath).item]
        return cell
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let commentView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CouponCollectionViewCell", for: indexPath) as! CouponCollectionViewCell
        return commentView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        let width = screenWidth * (162/375)
        let height = screenHeight * (172/667)
        return CGSize(width: width, height: height)
    }
    
}

//MARK: - UICollectionViewDelegate
extension ShopViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCoupon = self.shopCoupon[(indexPath as NSIndexPath).item]
        if let _ = selectedCoupon.needLogin {
            if selectedCoupon.needLogin! {
                if UserDataManager.isLoggedIn() {
                    self.getCouponDetail(selectedCoupon.couponID)
                }else {
                    if let _ = self.previousSelectedIndexPath {
                        self.shopCoupon[(self.previousSelectedIndexPath! as NSIndexPath).item].showConfirmView = false
                        collectionView.reloadItems(at: [self.previousSelectedIndexPath!])
                        
                        self.shopCoupon[(indexPath as NSIndexPath).item].showConfirmView = true
                        collectionView.reloadItems(at: [indexPath])
                        self.previousSelectedIndexPath = indexPath
                    }else {
                        self.shopCoupon[(indexPath as NSIndexPath).item].showConfirmView = true
                        collectionView.reloadItems(at: [indexPath])
                        self.previousSelectedIndexPath = indexPath
                    }
                }
            }else {
                self.getCouponDetail(selectedCoupon.couponID)
            }
        }
    }
    
}
