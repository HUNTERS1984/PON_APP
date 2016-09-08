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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        self.title = "現在地付近でさがす"
        self.showBackButton()
        
        self.offerView.backgroundColor = UIColor(hex3: 0xfff, alpha: 0.5)
        self.offerViewBottomConstraint.constant -= 172
        self.hideOfferButton.hidden = true
        self.menuButton.hidden = false
        
        self.currentLocationButton.setImage(UIImage(named: "map_icon_location"), forState: .Normal)
        self.menuButton.setImage(UIImage(named: "map_icon_menu"), forState: .Normal)
        self.hideOfferButton.setImage(UIImage(named: "map_icon_down"), forState: .Normal)
    }

}

//MARK: - IBAction
extension HomeMapViewController {
    
    @IBAction func currentLocationButtonPressed(sender: AnyObject) {
        self.showOfferView()
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
        UIView.animateWithDuration(0.5) { 
            self.offerViewBottomConstraint.constant += 172
            self.hideOfferButton.hidden = false
            self.menuButton.hidden = true
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideOfferView() {
        UIView.animateWithDuration(0.5) {
            self.offerViewBottomConstraint.constant -= 172
            self.hideOfferButton.hidden = true
            self.menuButton.hidden = false
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