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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        self.title = "現在地付近でさがす"
        self.showBackButton()
        
        self.offerView.backgroundColor = UIColor.clearColor()
        self.hideOfferButton.hidden = true
        self.menuButton.hidden = false
        
        self.currentLocationButton.setImage(UIImage(named: "map_icon_location"), forState: .Normal)
        self.menuButton.setImage(UIImage(named: "map_icon_menu"), forState: .Normal)
        self.hideOfferButton.setImage(UIImage(named: "map_icon_down"), forState: .Normal)
        
        self.mapView.handler = self
        let myCellNib = UINib(nibName: "CouponCollectionViewCell", bundle: nil)
        offersCollectionView.registerNib(myCellNib, forCellWithReuseIdentifier: "CouponCollectionViewCell")
        
        let screenHeight = UIScreen.mainScreen().bounds.height
        self.offerViewBottomConstraint.constant -= (screenHeight * (196/667) - 20)
        self.getShopNearMyLocation()
    }
}

//MARK: - IBAction
extension HomeMapViewController {
    
    @IBAction func currentLocationButtonPressed(sender: AnyObject) {
        self.mapView.moveToCurentLocation()
    }
    
    @IBAction func menuButtonPressed(sender: AnyObject) {
        let vc = HomeMenuViewController.instanceFromStoryBoard("MainMenu")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func hideOfferButtonPressed(sender: AnyObject) {
        self.hideOfferView()
    }
    
    override func navCloseButtonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(false)
    }
    
}

//MARK: - Private Methods
extension HomeMapViewController {
    
    private func showOfferView(coupons: [Coupon]) {
        self.coupons = coupons
        self.offersCollectionView.reloadData {
            if self.offerShowed {
                return
            }else {
                self.offerShowed = true
                UIView.animateWithDuration(0.5) {
                    self.offerViewBottomConstraint.constant = 0
                    self.hideOfferButton.hidden = false
                    self.offerView.fadeIn(0.4)
                    self.menuButton.hidden = true
                    self.offerView.backgroundColor = UIColor(hex3: 0xfff, alpha: 0.5)
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    private func hideOfferView() {
        if !self.offerShowed {
            return
        }
        self.offerShowed = false
        UIView.animateWithDuration(0.5) {
            self.offerViewBottomConstraint.constant = -(self.offerView.bounds.height - 20)
            self.hideOfferButton.hidden = true
            self.offerView.fadeOut(0.4)
            self.menuButton.hidden = false
            self.offerView.backgroundColor = UIColor.clearColor()
            self.view.layoutIfNeeded()
        }
    }
    
    private func getShopByLattitudeAndLongitude(lattitude: Double, longitude: Double) {
        self.showHUD()
        ApiRequest.getShopByLattitudeAndLongitude(lattitude, longitude: longitude, pageIndex: 1) { (request: NSURLRequest?, result: ApiResponse?, error: NSError?) in
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
                        self.displayShop(responseShop, lattitude: lattitude, longitude: longitude, type: .New)
                    }else {
                        
                    }
                }
            }
        }
    }
    
    private func displayShop(shops: [Shop], lattitude: Double, longitude: Double, type: GetType) {
        switch type {
        case .New:
            self.mapView.moveCameraToLocation(CLLocationCoordinate2D(latitude: lattitude, longitude: longitude))
            self.mapView.shops = shops
            break
        case .LoadMore:
            break
        case .Reload:
            break
        }
    }
    
    private func getShopNearMyLocation() {
        self.showHUD()
        LocationManager.sharedInstance.currentLocation { (location: CLLocationCoordinate2D?, error: NSError?) -> () in
            self.hideHUD()
            if let _ = error {
                
            }else {
                self.getShopByLattitudeAndLongitude(location!.latitude, longitude: location!.longitude)
            }
        }
    }
    
}

//MARK: - UICollectionViewDataSource
extension HomeMapViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coupons.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CouponCollectionViewCell", forIndexPath: indexPath) as! CouponCollectionViewCell
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.mainScreen().scale
        let couponData = self.coupons[indexPath.item]
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            dispatch_async(dispatch_get_main_queue(), {
                cell.coupon = couponData
            })
        }
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

//MARK: - UICollectionViewDelegate
extension HomeMapViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let vc = CouponViewController.instanceFromStoryBoard("Coupon")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension HomeMapViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenHeight = UIScreen.mainScreen().bounds.height
        let screenWidth = UIScreen.mainScreen().bounds.width
        let width = screenWidth * (162/375)
        let height = screenHeight * (172/667)
        return CGSizeMake(width, height)
    }
    
}

extension HomeMapViewController: MapViewDelegate {
    
    func mapView(mapView: MapView!, didDragMarker marker: MapMarker!) {
        
    }
    
    func mapView(mapView: MapView!, didEndDraggingMarker marker: MapMarker!) {
        
    }
    
    func mapView(mapView: MapView!, didTapMarker marker: MapMarker!) {
        self.showOfferView(marker.shop.shopCoupons)
    }
    
    func mapView(mapView: MapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        self.hideOfferView()
    }
    
}