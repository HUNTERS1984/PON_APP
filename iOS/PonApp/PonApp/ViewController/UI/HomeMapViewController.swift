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
    var coupons = [Coupon]() {
        didSet {
        }
    }
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
    }
}

//MARK: - IBAction
extension HomeMapViewController {
    
    @IBAction func currentLocationButtonPressed(_ sender: AnyObject) {
        self.mapView.moveToCurentLocation()
    }
    
    @IBAction func menuButtonPressed(_ sender: AnyObject) {
        let vc = HomeMenuViewController.instanceFromStoryBoard("MainMenu")
        self.navigationController?.pushViewController(vc!, animated: true)
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
    
    fileprivate func showOfferView(_ coupons: [Coupon]) {
        self.coupons = coupons
        self.offersCollectionView.reloadData {
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
        ApiRequest.getShopByLattitudeAndLongitude(lattitude, longitude: longitude, pageIndex: 1) { (request: URLRequest?, result: ApiResponse?, error: NSError?) in
            self.hideHUD()
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
                        self.displayShop(responseShop, lattitude: lattitude, longitude: longitude, type: .new)
                    }else {
                        
                    }
                }
            }
        }
    }
    
    fileprivate func displayShop(_ shops: [Shop], lattitude: Double, longitude: Double, type: GetType) {
        switch type {
        case .new:
            self.mapView.moveCameraToLocation(CLLocationCoordinate2D(latitude: lattitude, longitude: longitude))
            self.mapView.shops = shops
            break
        case .loadMore:
            break
        case .reload:
            break
        }
    }
    
    fileprivate func getShopNearMyLocation() {
        self.showHUD()
        LocationManager.sharedInstance.currentLocation { (location: CLLocationCoordinate2D?, error: NSError?) -> () in
            self.hideHUD()
            if let _ = error {
                
            }else {
                self.mapView.moveCameraToLocation(location!)
                self.getShopByLattitudeAndLongitude(location!.latitude, longitude: location!.longitude)
            }
        }
    }
    
    fileprivate func getCouponDetail(_ couponId: Float) {
        self.showHUD()
        ApiRequest.getCouponDetail(couponId) { (request: URLRequest?, result: ApiResponse?, error: NSError?) in
            self.hideHUD()
            if let _ = error {
                
            }else {
                if result?.code == SuccessCode {
                    let coupon = Coupon(response: result?.data)
                    let vc = CouponViewController.instanceFromStoryBoard("Coupon") as! CouponViewController
                    vc.coupon = coupon
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    fileprivate func resetCollectionView() {
        if let _ = self.previousSelectedIndexPath {
            self.coupons[(self.previousSelectedIndexPath! as NSIndexPath).item].showConfirmView = false
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
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale
        let couponData = self.coupons[(indexPath as NSIndexPath).item]
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async(execute: {
                cell.coupon = couponData
            })
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
        let selectedCoupon = self.coupons[(indexPath as NSIndexPath).item]
        if let _ = selectedCoupon.canUse {
            if selectedCoupon.canUse! {
                self.resetCollectionView()
                self.getCouponDetail(selectedCoupon.couponID)
            }else {
                if let _ = self.previousSelectedIndexPath {
                    if indexPath == self.previousSelectedIndexPath! {
                        return
                    }
                    self.coupons[(self.previousSelectedIndexPath! as NSIndexPath).item].showConfirmView = false
                    collectionView.reloadItems(at: [self.previousSelectedIndexPath!])
                    
                    self.coupons[(indexPath as NSIndexPath).item].showConfirmView = true
                    collectionView.reloadItems(at: [indexPath])
                    self.previousSelectedIndexPath = indexPath
                }else {
                    self.coupons[(indexPath as NSIndexPath).item].showConfirmView = true
                    collectionView.reloadItems(at: [indexPath])
                    self.previousSelectedIndexPath = indexPath
                }
            }
        }
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension HomeMapViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        let width = screenWidth * (162/375)
        let height = screenHeight * (172/667)
        return CGSize(width: width, height: height)
    }
    
}

extension HomeMapViewController: MapViewDelegate {
    
    func mapView(_ mapView: MapView!, didDragMarker marker: MapMarker!) {
        
    }
    
    func mapView(_ mapView: MapView!, didEndDraggingMarker marker: MapMarker!) {
        
    }
    
    func mapView(_ mapView: MapView!, didTapMarker marker: MapMarker!) {
        self.showOfferView(marker.shop.shopCoupons)
    }
    
    func mapView(_ mapView: MapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        self.hideOfferView()
    }
    
}
