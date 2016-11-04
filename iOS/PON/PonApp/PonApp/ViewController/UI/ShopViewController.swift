//
//  ShopViewController.swift
//  PonApp
//
//  Created by HaoLe on 9/12/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit
import MapKit

let NavBarChangePoint: CGFloat = 50.0
let HeaderChangePoint: CGFloat = 20.0

class ShopViewController: BaseViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var shopAvatar: CircleImageView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var albumCollectionView: AlbumCollectionView!
    @IBOutlet weak var albumCollectionViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var couponCollectionView: UICollectionView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var shopId: UILabel!
    @IBOutlet weak var addressLabel: PaddingLabel!
    @IBOutlet weak var accessLabel: PaddingLabel!
    @IBOutlet weak var industriTime: UILabel!
    @IBOutlet weak var holidayLabel: UILabel!
    @IBOutlet weak var meanCountLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var detailMapView: MapView!
    @IBOutlet weak var headerContentView: UIView!

    var coupons = [Coupon]() {
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
        self.callNumber(phoneNumber: self.shop!.shopPhonenumber)
    }
    
    @IBAction func locationButtonPressed(_ sender: AnyObject) {
        self.directionToShop(self.shop!.coordinate, self.shop!.shopAddress)
    }
    
    @IBAction func shareButtonPressed(_ sender: AnyObject) {

    }
    
    @IBAction override func backButtonPressed(_ sender: AnyObject) {
        self.navigationController!.popViewController(animated: true)
    }
    
}

//MARK: - Private
extension ShopViewController {
    
    fileprivate func directionToShop(_ coordinate: CLLocationCoordinate2D, _ address: String) {
        let currentLocation = MKMapItem.forCurrentLocation()
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let destinationLocation = MKMapItem(placemark: placemark)
        destinationLocation.name = address
        let options = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ]
        let openMapsWithItems = [currentLocation, destinationLocation]
        MKMapItem.openMaps(with: openMapsWithItems, launchOptions: options)
    }
    
    fileprivate func callNumber(phoneNumber:String) {
        if let phoneCallURL = URL(string:"tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.openURL(phoneCallURL);
            }
        }
    }
    
    fileprivate func displayShopDetail(_ shop: Shop) {
        self.shopAvatar.af_setImage(withURL: URL(string: shop.avatarUrl)!)
        self.shopNameLabel.text = shop.title
        self.navTitleLabel.text = shop.title
        shopId.text = "\(shop.shopID!)"
        addressLabel.text = shop.shopAddress
        self.addressLabel.setLineHeight(lineHeight: 1.75)
        accessLabel.text = shop.shopDirection
        self.accessLabel.setLineHeight(lineHeight: 1.75)
        industriTime.text = "\(shop.shopStartTime!)~\(shop.shopEndTime!)"
        holidayLabel.text = shop.regularHoliday
        meanCountLabel.text = "~\(shop.shopAvegerBill!)円"
        phoneNumberLabel.text = shop.shopPhonenumber
        self.coupons = shop.coupons
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
    
    fileprivate func getCouponDetail(_ couponId: Float, selectedCouponIndex: Int? = nil) {
        self.showHUD()
        ApiRequest.getCouponDetail(couponId, hasAuth: UserDataManager.isLoggedIn()) { (request: URLRequest?, result: ApiResponse?, error: NSError?) in
            self.hideHUD()
            if let _ = error {
                
            }else {
                if result?.code == SuccessCode {
                    let coupon = Coupon(response: result?.data)
                    let vc = CouponViewController.instanceFromStoryBoard("Coupon") as! CouponViewController
                    vc.coupon = coupon
                    vc.handler = self
                    vc.selectedCouponIndex = selectedCouponIndex
                    self.navigationController!.pushViewController(vc, animated: true)
                }else {
                    self.presentAlert(message: (result?.message)!)
                }
            }
        }
    }
    
    fileprivate func resetCollectionView() {
        if let _ = self.previousSelectedIndexPath {
            self.coupons[self.previousSelectedIndexPath!.item].showConfirmView = false
            couponCollectionView.reloadItems(at: [self.previousSelectedIndexPath!])
            self.previousSelectedIndexPath = nil
        }
    }
}

//MARK: - UIScrollViewDelegate
extension ShopViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isKind(of: UICollectionView.classForCoder()) {
            return
        }else {
            let color = UIColor(hex: DefaultBlueTextColor)
            let offsetY = scrollView.contentOffset.y
            let alpha = min(1, 1 - ((HeaderChangePoint + 34 - offsetY) / 34))
            if offsetY > HeaderChangePoint {
                self.headerContentView.alpha = 1 - alpha
            }else {
                self.headerContentView.alpha = 1
            }
            
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
        return self.coupons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CouponCollectionViewCell", for: indexPath) as! CouponCollectionViewCell
        cell.coupon = self.coupons[indexPath.item]
        cell.completionHandler = { [weak self] in
            self?.openSignUp()
        }
        return cell
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        let width = screenWidth * (164/375)
        let height = screenHeight * (176/667)
        return CGSize(width: width, height: height)
    }
    
}

//MARK: - UICollectionViewDelegate
extension ShopViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCoupon = self.coupons[indexPath.item]
        if let _ = selectedCoupon.needLogin {
            if selectedCoupon.needLogin! {
                if UserDataManager.isLoggedIn() {
                    self.resetCollectionView()
                    self.getCouponDetail(selectedCoupon.couponID, selectedCouponIndex: indexPath.item)
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
                self.getCouponDetail(selectedCoupon.couponID, selectedCouponIndex: indexPath.item)
            }
        }
    }
    
}


//MARK: - CouponViewControllerDelegate
extension ShopViewController: CouponViewControllerDelegate {
    
    func couponViewController(_ viewController: CouponViewController, didLikeCouponAtIndex index: Int?, rowIndex: Int?, couponId: Float?) {
        guard let couponId = couponId,
            let index = index else {
                return
        }
        if self.coupons[index].couponID == couponId {
            self.coupons[index].isLike = true
            self.couponCollectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
        }
        
    }
}
