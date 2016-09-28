//
//  HomeNearestViewController.swift
//  PonApp
//
//  Created by HaoLe on 9/8/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class HomeNearestViewController: BaseViewController {

    var parentNavigationController : UINavigationController?
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var contentTableView: UITableView!
    @IBOutlet weak var contentTableViewHeight: NSLayoutConstraint!
    
    var couponListData = [CouponListData]()
    var previousCollectionView: HorizontalCollectionView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        let myCellNib = UINib(nibName: "CouponCollectionTableViewCell", bundle: nil)
        contentTableView.registerNib(myCellNib, forCellReuseIdentifier: "CouponCollectionTableViewCell")
        self.contentTableView.scrollEnabled = false
        self.contentTableView.allowsSelection = false
        self.contentTableView.separatorStyle = .None
        self.getCoupon(1)
    }
    
}

//MARK: - Private
extension HomeNearestViewController {
    
    private func getCouponDetail(couponId: Float) {
        self.showHUD()
        ApiRequest.getCouponDetail(couponId) { (request: NSURLRequest?, result: ApiResponse?, error: NSError?) in
            self.hideHUD()
            if let _ = error {
                
            }else {
                let coupon = Coupon(response: result?.data)
                let vc = CouponViewController.instanceFromStoryBoard("Coupon") as! CouponViewController
                vc.coupon = coupon
                self.parentNavigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}

//MARK: - UITableViewDataSource
extension HomeNearestViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return couponListData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CouponCollectionTableViewCell", forIndexPath: indexPath) as! CouponCollectionTableViewCell
        cell.moreButtonCallback = {(sender) -> Void in
            
        }
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let collectionCell = cell as! CouponCollectionTableViewCell
        collectionCell.couponCollectionView.index = indexPath.row
        collectionCell.setCollectionViewDelegate(delegate: self, index: indexPath.row, coupons: self.couponListData[indexPath.row].coupons)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let screenHeight = UIScreen.mainScreen().bounds.height
        let height = screenHeight * (234/667)
        return height
    }
    
}

//MARK: - UITableViewDelegate
extension HomeNearestViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}

extension HomeNearestViewController: HorizontalCollectionViewDelegate {
    
    func horizontalCollectionView(collectionView: HorizontalCollectionView, didSelectCoupon coupon: Coupon?, atIndexPath indexPath: NSIndexPath) {
        if let _ = self.previousCollectionView {
            if self.previousCollectionView! != collectionView {
                self.previousCollectionView!.resetCollectionView()
            }
        }
        self.previousCollectionView = collectionView
        if let _ = coupon {
            self.getCouponDetail(coupon!.couponID)
        }
    }
    
}

//MARK: - Private
extension HomeNearestViewController {
    
    private func getCoupon(pageIndex: Int) {
        self.showHUD()
        ApiRequest.getCouponByFeature(.Near) { (request: NSURLRequest?, result: ApiResponse?, error: NSError?) in
            self.hideHUD()
            if let _ = error {
                
            }else {
                var responseData = [CouponListData]()
                let couponsArray = result?.data?.array
                if let _ = couponsArray {
                    for couponData in couponsArray! {
                        let data = CouponListData(response: couponData)
                        responseData.append(data)
                    }
                    if pageIndex == 1 {
                        self.displayData(responseData, type: .New)
                    }else {
                        self.displayData(responseData, type: .LoadMore)
                    }
                }else {
                    
                }
            }
        }
    }
    
    private func displayData(data: [CouponListData], type: GetType) {
        switch type {
        case .New:
            self.couponListData.removeAll()
            self.couponListData = data
            self.contentTableView.reloadData {
                let heightConstant = self.contentTableView.contentSize.height
                self.contentTableViewHeight.constant = heightConstant;
            }
            break
        case .LoadMore:
            self.couponListData.appendContentsOf(data)
            self.contentTableView.reloadData {
                let heightConstant = self.contentTableView.contentSize.height
                self.contentTableViewHeight.constant = heightConstant;
            }
            break
        case .Reload:
            break
        }
    }
    
}


