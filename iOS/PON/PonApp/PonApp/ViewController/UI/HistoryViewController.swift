//
//  HistoryViewController.swift
//  PonApp
//
//  Created by HaoLe on 9/27/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class HistoryViewController: BaseViewController {

    @IBOutlet weak var collectionView:UICollectionView!
    
    var coupons = [Coupon]()
    
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
        self.title = "履歴 \(UserDataManager.shared.usedCouponNumber)"
        self.showBackButton()
        
        let myCellNib = UINib(nibName: "CouponCollectionViewCell", bundle: nil)
        collectionView.register(myCellNib, forCellWithReuseIdentifier: "CouponCollectionViewCell")
        
        self.loadUsedCoupon(1)
    }
    
    override func setUpComponentsOnWillAppear() {
        super.setUpComponentsOnWillAppear()
    }
    
}

//MARK: - IBAction
extension HistoryViewController {
    
}

//MARK: - Private
extension HistoryViewController {
    
    fileprivate func loadUsedCoupon(_ pageIndex: Int) {
        self.showHUD()
        ApiRequest.getUsedCoupon(pageIndex: pageIndex) {(request: URLRequest?, result: ApiResponse?, error: NSError?) in
            self.hideHUD()
            if let _ = error {
                
            }else {
                if result?.code == SuccessCode {
                    var responseCoupon = [Coupon]()
                    let couponsArray = result?.data?.array
                    if let _ = couponsArray {
                        for couponData in couponsArray! {
                            var coupon = Coupon(response: couponData)
                            coupon.isUsed = true
                            responseCoupon.append(coupon)
                        }
                        if pageIndex == 1 {
                            self.displayCoupon(responseCoupon, type: .new)
                        }else {
                            self.displayCoupon(responseCoupon, type: .loadMore)
                        }
                    }
                }else {
                    self.presentAlert(message: (result?.message)!)
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
                    self.navigationController!.pushViewController(vc, animated: true)
                }else {
                    self.presentAlert(message: (result?.message)!)
                }
            }
        }
    }
    
}

//MARK: - UICollectionViewDataSource
extension HistoryViewController: UICollectionViewDataSource {
    
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
extension HistoryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCoupon = self.coupons[(indexPath as NSIndexPath).item]
        self.getCouponDetail(selectedCoupon.couponID)
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension HistoryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenHeight = UIScreen.main.bounds.height
        let width = (self.view.frame.size.width - 22) / 2.0
        let height = screenHeight * (188/667)
        return CGSize(width: width, height: height)
    }
    
}
