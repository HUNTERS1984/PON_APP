//
//  SearchResultViewController.swift
//  PonApp
//
//  Created by HaoLe on 12/9/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class SearchResultViewController: BaseViewController {

    @IBOutlet weak var collectionView:UICollectionView!
    open var coupons = [Coupon]()
    
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
        self.title = "お気に入り"
        self.showBackButton()
        let myCellNib = UINib(nibName: "CouponCollectionViewCell", bundle: nil)
        collectionView.register(myCellNib, forCellWithReuseIdentifier: "CouponCollectionViewCell")
    }
    

}

extension SearchResultViewController {
    
    fileprivate func getCouponDetail(_ couponId: Float, selectedCouponIndex: Int? = nil) {
        self.showHUD()
        ApiRequest.getCouponDetail(couponId, hasAuth: UserDataManager.isLoggedIn()) { (request: URLRequest?, result: ApiResponse?, error: NSError?) in
            self.hideHUD()
            if let _ = error {
                
            }else {
                if result?.code == SuccessCode {
                    let coupon = Coupon(response: result?.data)
                    let vc = CouponViewController.instanceFromStoryBoard("Coupon") as! CouponViewController
                    vc.selectedCouponIndex = selectedCouponIndex
                    vc.handler = self
                    vc.coupon = coupon
                    self.navigationController?.pushViewController(vc, animated: true)
                }else {
                    self.presentAlert(message: (result?.message)!)
                }
            }
        }
    }
    
}

//MARK: - UICollectionViewDataSource
extension SearchResultViewController: UICollectionViewDataSource {
    
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
extension SearchResultViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCoupon = self.coupons[indexPath.item]
        self.getCouponDetail(selectedCoupon.couponID, selectedCouponIndex: indexPath.item)
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension SearchResultViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenHeight = UIScreen.main.bounds.height
        let width = (self.view.frame.size.width - 22) / 2.0
        let height = screenHeight * (188/667)
        return CGSize(width: width, height: height)
    }
    
}

//MARK: - CouponViewControllerDelegate
extension SearchResultViewController: CouponViewControllerDelegate {
    
    internal func couponViewController(_ viewController: CouponViewController, didUpdateLikeCouponStatusAtIndex index: Int?, rowIndex: Int?, couponId: Float?, status: Bool) {
        guard let couponId = couponId,
            let index = index else {
                return
        }
        if self.coupons[index].couponID == couponId {
            self.coupons[index].isLike = status
            self.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
        }
        
    }
    
}
