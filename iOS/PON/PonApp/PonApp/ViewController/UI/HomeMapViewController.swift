//
//  HomeMapViewController.swift
//  PonApp
//
//  Created by HaoLe on 9/5/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class HomeMapViewController: BaseViewController {

    @IBOutlet weak var offerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var offerView: UIView!
    @IBOutlet weak var actionView: UIView!
    
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var hideOfferButton: UIButton!
    @IBOutlet weak var mapView: MapView!
    @IBOutlet weak var offersCollectionView:UICollectionView!
    
    var offerShowed: Bool = false
    var coupons = [Coupon]()
    var shops = [Shop]()
    
    var previousSelectedIndexPath: IndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func startGoogleAnalytics() {
        super.startGoogleAnalytics()
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: GAScreen_Map)
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        self.title = "現在地付近でさがす"
        self.showBackButton()
        
        self.offerView.backgroundColor = UIColor.clear
        self.hideOfferButton.isHidden = true
        self.menuButton.isHidden = false
        
        self.currentLocationButton.setImage(UIImage(named: "map_icon_location"), for: UIControlState())
        self.menuButton.setImage(UIImage(named: "map_icon_menu"), for: UIControlState())
        self.hideOfferButton.setImage(UIImage(named: "map_icon_down"), for: UIControlState())
        
        self.mapView.handler = self
        let myCellNib = UINib(nibName: "CouponCollectionViewCell", bundle: nil)
        offersCollectionView.register(myCellNib, forCellWithReuseIdentifier: "CouponCollectionViewCell")
        
        let screenHeight = UIScreen.main.bounds.height
        self.offerViewBottomConstraint.constant -= (screenHeight * (196/667) - 20)
        self.getShopNearMyLocation()
        //self.getShopByLattitudeAndLongitude(10.839812, longitude: 106.780339)
    }
}

//MARK: - IBAction
extension HomeMapViewController {
    
    @IBAction func currentLocationButtonPressed(_ sender: AnyObject) {
        self.mapView.moveToCurentLocation()
    }
    
    @IBAction func menuButtonPressed(_ sender: AnyObject) {
        self.showOfferView()
    }
    
    @IBAction func hideOfferButtonPressed(_ sender: AnyObject) {
        self.hideOfferView()
    }
    
    override func navCloseButtonPressed(_ sender: AnyObject) {
        self.navigationController!.popViewController(animated: false)
    }
    
}

//MARK: - Private Methods
extension HomeMapViewController {
    
    fileprivate func displayCoupon() {
        var shopCoupons = [Coupon]()
        for shop in shops {
            shopCoupons.append(contentsOf: shop.coupons)
        }
        self.coupons.removeAll()
        self.coupons = shopCoupons
        self.offersCollectionView.reloadData()
    }
    
    fileprivate func showOfferView() {
        if self.offerShowed {
            return
        }else {
            self.offerShowed = true
            UIView.animate(withDuration: 0.5, animations: {
                self.offerViewBottomConstraint.constant = 0
                self.hideOfferButton.isHidden = false
                self.offerView.fadeIn(0.4)
                self.menuButton.isHidden = true
                self.offerView.backgroundColor = UIColor(hex3: 0xfff, alpha: 0.5)
                self.view.layoutIfNeeded()
            })
        }
    }
    
    fileprivate func hideOfferView() {
        if !self.offerShowed {
            return
        }
        self.offerShowed = false
        UIView.animate(withDuration: 0.5, animations: {
            self.offerViewBottomConstraint.constant = -(self.offerView.bounds.height - 20)
            self.hideOfferButton.isHidden = true
            self.offerView.fadeOut(0.4)
            self.menuButton.isHidden = false
            self.offerView.backgroundColor = UIColor.clear
            self.view.layoutIfNeeded()
        }) 
    }
    
    fileprivate func getShopByLattitudeAndLongitude(_ lattitude: Double, longitude: Double) {
        self.showHUD()
        ApiRequest.getShopByLattitudeAndLongitude(lattitude, longitude: longitude, hasAuth: UserDataManager.isLoggedIn(), pageIndex: 1) {[weak self] (request: URLRequest?, result: ApiResponse?, error: NSError?) in
            self?.hideHUD()
            if let _ = error {
                
            }else {
                if result?.code == SuccessCode {
                    var responseShop = [Shop]()
                    let shopArray = result?.data?.array
                    if let _ = shopArray {
                        for shopData in shopArray! {
                            let shop = Shop(response: shopData)
                            responseShop.append(shop)
                        }
                        self?.displayShop(responseShop, lattitude: lattitude, longitude: longitude, type: .new)
                    }
                }else {
                    self?.presentAlert(message: (result?.message)!)
                }
            }
        }
    }
    
    fileprivate func displayShop(_ shops: [Shop], lattitude: Double, longitude: Double, type: GetType) {
        switch type {
        case .new:
            self.shops.removeAll()
            self.mapView.moveCameraToLocation(CLLocationCoordinate2D(latitude: lattitude, longitude: longitude))
            self.mapView.shops = shops
            self.shops = shops
            self.displayCoupon()
            break
        case .loadMore:
            break
        case .reload:
            break
        }
    }
    
    fileprivate func getShopNearMyLocation() {
        self.showHUD()
        LocationManager.sharedInstance.currentLocation { [weak self] (location: CLLocationCoordinate2D?, error: NSError?) -> () in
            self?.hideHUD()
            if let _ = error {
                
            }else {
                self?.mapView.moveCameraToLocation(location!)
                self?.getShopByLattitudeAndLongitude(location!.latitude, longitude: location!.longitude)
            }
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
                    vc.selectedCouponIndex = selectedCouponIndex
                    vc.handler = self
                    self.navigationController?.pushViewController(vc, animated: true)
                }else {
                    self.presentAlert(message: (result?.message)!)
                }
            }
        }
    }
    
    fileprivate func resetCollectionView() {
        if let _ = self.previousSelectedIndexPath {
            self.coupons[self.previousSelectedIndexPath!.item].showConfirmView = false
            offersCollectionView.reloadItems(at: [self.previousSelectedIndexPath!])
            self.previousSelectedIndexPath = nil
        }
    }
    
}

//MARK: - UICollectionViewDataSource
extension HomeMapViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coupons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CouponCollectionViewCell", for: indexPath) as! CouponCollectionViewCell
        let couponData = self.coupons[indexPath.item]
        cell.coupon = couponData
        cell.completionHandler = { [weak self] in
            self?.openSignUp()
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

//MARK: - UICollectionViewDelegate
extension HomeMapViewController: UICollectionViewDelegate {
    
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

//MARK: - UICollectionViewDelegateFlowLayout
extension HomeMapViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        let width = screenWidth * (154/375)
        let height = screenHeight * (164/667)
        return CGSize(width: width, height: height)
    }
    
}

extension HomeMapViewController: MapViewDelegate {
    
    func mapView(_ mapView: MapView!, didDragMarker marker: MapMarker!) {
        
    }
    
    func mapView(_ mapView: MapView!, didEndDraggingMarker marker: MapMarker!) {
        
    }
    
    func mapView(_ mapView: MapView!, didTapMarker marker: MapMarker!) {
        
    }
    
    func mapView(_ mapView: MapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        self.hideOfferView()
    }
    
}

//MARK: - CouponViewControllerDelegate
extension HomeMapViewController: CouponViewControllerDelegate {
    internal func couponViewController(_ viewController: CouponViewController, didUpdateLikeCouponStatusAtIndex index: Int?, rowIndex: Int?, couponId: Float?, status: Bool) {
        guard let couponId = couponId,
            let index = index else {
                return
        }
        if self.coupons[index].couponID == couponId {
            self.coupons[index].isLike = status
            self.offersCollectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
        }
    }
    
}
