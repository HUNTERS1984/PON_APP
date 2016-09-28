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
        collectionCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, index: indexPath.row)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let screenHeight = UIScreen.mainScreen().bounds.height
        let height = screenHeight * (234/667)
        return height
    }
    
}

extension HomeNearestViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension HomeNearestViewController:UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let listView = collectionView as! HorizontalCollectionView
        let index = listView.index
        return self.couponListData[index].coupons.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CouponCollectionViewCell", forIndexPath: indexPath) as! CouponCollectionViewCell
        let listView = collectionView as! HorizontalCollectionView
        let index = listView.index
        cell.coupon = self.couponListData[index].coupons[indexPath.item]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let commentView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "CouponCollectionViewCell", forIndexPath: indexPath) as! CouponCollectionViewCell
        return commentView
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let vc = CouponViewController.instanceFromStoryBoard("Coupon")
        self.parentNavigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenHeight = UIScreen.mainScreen().bounds.height
        let screenWidth = UIScreen.mainScreen().bounds.width
        let width = screenWidth * (162/375)
        let height = screenHeight * (172/667)
        return CGSizeMake(width, height)
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


