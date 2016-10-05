//
//  ListCouponContentViewController.swift
//  PonApp
//
//  Created by OSXVN on 9/28/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class ListCouponContentViewController: BaseViewController {
    
    @IBOutlet weak var collectionView:UICollectionView!
    
    var parentNavigationController : UINavigationController?
    var couponFeature:CouponFeature?
    var couponCategoryID: Int?
    
    var coupons = [Coupon]()
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
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        let myCellNib = UINib(nibName: "CouponCollectionViewCell", bundle: nil)
        collectionView.register(myCellNib, forCellWithReuseIdentifier: "CouponCollectionViewCell")

        self.getCouponByFeatureAndType(1)
    }
    
    override func setUpComponentsOnWillAppear() {
        super.setUpComponentsOnWillAppear()
    }
    
}

//MARK: - IBAction
extension ListCouponContentViewController {
    
}

//MARK: - Private
extension ListCouponContentViewController {
    
    fileprivate func getCouponByFeatureAndType(_ pageIndex: Int) {
        self.showHUD()
        ApiRequest.getCouponByFeatureAndType(self.couponFeature!, couponType: self.couponCategoryID!, pageIndex: 1) {(request: URLRequest?, result: ApiResponse?, error: NSError?) in
            self.hideHUD()
            if let _ = error {
                
            }else {
                if result?.code == SuccessCode {
                    var responseCoupon = [Coupon]()
                    let couponsArray = result?.data?["coupons"].array
                    if let _ = couponsArray {
                        for couponData in couponsArray! {
                            let coupon = Coupon(response: couponData)
                            responseCoupon.append(coupon)
                        }
                        if pageIndex == 1 {
                            self.displayCoupon(responseCoupon, type: .new)
                        }else {
                            self.displayCoupon(responseCoupon, type: .loadMore)
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func displayCoupon(_ coupons: [Coupon], type: GetType) {
        switch type {
        case .new:
            self.coupons.removeAll()
            self.coupons = coupons
            self.collectionView.reloadData()
            break
        case .loadMore:
            self.coupons.append(contentsOf: coupons)
            self.collectionView.reloadData()
            break
        case .reload:
            break
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
                    self.parentNavigationController?.pushViewController(vc, animated: true)
                }else {
                    self.presentAlert(message: (result?.message)!)
                }
            }
        }
    }
    
    fileprivate func resetCollectionView() {
        if let _ = self.previousSelectedIndexPath {
            self.coupons[(self.previousSelectedIndexPath! as NSIndexPath).item].showConfirmView = false
            collectionView.reloadItems(at: [self.previousSelectedIndexPath!])
            self.previousSelectedIndexPath = nil
        }
    }
    
}

//MARK: - UICollectionViewDataSource
extension ListCouponContentViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coupons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CouponCollectionViewCell", for: indexPath) as! CouponCollectionViewCell
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale
        let couponTest = self.coupons[(indexPath as NSIndexPath).item]
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async(execute: {
                cell.coupon = couponTest
            })
        }
        return cell
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let commentView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CouponCollectionViewCell", for: indexPath) as! CouponCollectionViewCell
        return commentView
    }
    
}

//MARK: - UICollectionViewDelegate
extension ListCouponContentViewController: UICollectionViewDelegate {
    
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
extension ListCouponContentViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenHeight = UIScreen.main.bounds.height
        let width = (self.view.frame.size.width - 30) / 2.0
        let height = screenHeight * (189/667)
        return CGSize(width: width, height: height)
    }
    
}
