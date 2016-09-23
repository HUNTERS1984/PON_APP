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
    
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var hideOfferButton: UIButton!
    @IBOutlet weak var mapView: MapView!
    @IBOutlet weak var offersCollectionView:UICollectionView!
    
    var offerShowed: Bool = false
    
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
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        self.title = "現在地付近でさがす"
        self.showBackButton()
        
        self.offerView.backgroundColor = UIColor.clearColor()
        self.offerViewBottomConstraint.constant -= 172
        self.hideOfferButton.hidden = true
        self.menuButton.hidden = false
        
        self.currentLocationButton.setImage(UIImage(named: "map_icon_location"), forState: .Normal)
        self.menuButton.setImage(UIImage(named: "map_icon_menu"), forState: .Normal)
        self.hideOfferButton.setImage(UIImage(named: "map_icon_down"), forState: .Normal)
        
        self.mapView.handler = self
        let myCellNib = UINib(nibName: "CouponCollectionViewCell", bundle: nil)
        offersCollectionView.registerNib(myCellNib, forCellWithReuseIdentifier: "CouponCollectionViewCell")
    }

}

//MARK: - IBAction
extension HomeMapViewController {
    
    @IBAction func currentLocationButtonPressed(sender: AnyObject) {
        self.mapView.moveToCurentLocation()
    }
    
    @IBAction func menuButtonPressed(sender: AnyObject) {
        let vc = HomeMenuViewController.instanceFromStoryBoard("MainMenu")
        self.navigationController?.pushViewController(vc, animated: false)
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
    
    private func showOfferView() {
        if self.offerShowed {
            return
        }
        self.offerShowed = true
        UIView.animateWithDuration(0.5) {
            self.offerViewBottomConstraint.constant += 172
            self.hideOfferButton.hidden = false
            self.menuButton.hidden = true
            self.offerView.backgroundColor = UIColor(hex3: 0xfff, alpha: 0.5)
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideOfferView() {
        if !self.offerShowed {
            return
        }
        self.offerShowed = false
        UIView.animateWithDuration(0.5) {
            self.offerViewBottomConstraint.constant -= 172
            self.hideOfferButton.hidden = true
            self.menuButton.hidden = false
            self.offerView.backgroundColor = UIColor.clearColor()
            self.view.layoutIfNeeded()
        }
    }
    
}

//MARK: - UICollectionViewDataSource
extension HomeMapViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CouponCollectionViewCell", forIndexPath: indexPath) as! CouponCollectionViewCell
        cell.coupon = Coupon.init()
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
extension HomeMapViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let vc = CouponViewController.instanceFromStoryBoard("Coupon")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension HomeMapViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(150, 160)
    }
    
}

extension HomeMapViewController: MapViewDelegate {
    
    func mapView(mapView: MapView!, didDragMarker marker: MapMarker!) {
        
    }
    
    func mapView(mapView: MapView!, didEndDraggingMarker marker: MapMarker!) {
        
    }
    
    func mapView(mapView: MapView!, didTapMarker marker: MapMarker!) {
        self.showOfferView()
    }
    
    func mapView(mapView: MapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        self.hideOfferView()
    }
    
}