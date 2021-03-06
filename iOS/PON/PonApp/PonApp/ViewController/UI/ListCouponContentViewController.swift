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
    
    open weak var parentNavigationController : UINavigationController?
    var feature: CouponFeature?
    var categoryID: Int?
    
    var coupons = [Coupon]()
    var previousSelectedIndexPath: IndexPath? = nil
    
    //paging
    var canLoadMore: Bool = true
    var currentPage: Int = 1
    var totalPage: Int = 1
    var nextPage: Int = 1
    
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

        self.getCoupon(self.feature!, category: self.categoryID!, pageIndex: currentPage)
    }
    
}

//MARK: - Private
extension ListCouponContentViewController {
    
    fileprivate func getCoupon(_ feature:CouponFeature, category: Int, pageIndex: Int) {
        if feature == .near {
            self.showHUD()
            LocationManager.sharedInstance.currentLocation { (location: CLLocationCoordinate2D?, error: NSError?) -> () in
                self.hideHUD()
                if let _ = error {
                    
                }else {
                    self.getCouponByFeatureAndType(feature, category:category, longitude: location!.longitude, lattitude: location!.latitude, pageIndex: pageIndex)
                }
            }
        }else {
            self.getCouponByFeatureAndType(feature, category:category, pageIndex: pageIndex)
        }
    }
    
    fileprivate func getCouponByFeatureAndType(_ feature:CouponFeature, category: Int, longitude: Double? = nil, lattitude: Double? = nil, pageIndex: Int) {
        self.showHUD()
        ApiRequest.getCouponByFeatureAndType(feature, category: category, hasAuth: UserDataManager.isLoggedIn(), longitude: longitude, lattitude: lattitude, pageIndex: pageIndex) {(request: URLRequest?, result: ApiResponse?, error: NSError?) in
            self.hideHUD()
            if let _ = error {
                
            }else {
                if result?.code == SuccessCode {
                    self.nextPage = result!.nextPage
                    self.totalPage = result!.totalPage
                    self.currentPage = result!.currentPage
                    
                    var responseCoupon = [Coupon]()
                    let couponsArray = result?.data?.array
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
                    self.parentNavigationController?.pushViewController(vc, animated: true)
                }else {
                    self.presentAlert(message: (result?.message)!)
                }
            }
        }
    }
    
    fileprivate func resetCollectionView() {
        if let _ = self.previousSelectedIndexPath {
            self.coupons[self.previousSelectedIndexPath!.item].showConfirmView = false
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
        let couponTest = self.coupons[indexPath.item]
        cell.coupon = couponTest
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
extension ListCouponContentViewController: UICollectionViewDelegate {
    
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
extension ListCouponContentViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenHeight = UIScreen.main.bounds.height
        let width = (self.view.frame.size.width - 22) / 2.0
        let height = screenHeight * (188/667)
        return CGSize(width: width, height: height)
    }
    
}

//MARK: - UIScrollViewDelegate
extension ListCouponContentViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.currentPage == self.totalPage {
            return
        }
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height && canLoadMore {
            canLoadMore = false
            self.getCoupon(self.feature!, category: self.categoryID!, pageIndex: self.nextPage)
        }
    }
    
}

//MARK: - CouponViewControllerDelegate
extension ListCouponContentViewController: CouponViewControllerDelegate {
    
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
