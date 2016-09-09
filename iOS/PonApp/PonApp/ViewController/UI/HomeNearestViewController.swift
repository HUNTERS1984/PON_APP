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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("self.contentTableView.contentSize.height: \(self.contentTableView.contentSize.height)")
        self.contentTableViewHeight.constant = 1110
        print("\(self.contentTableViewHeight.constant)")
        print("\(self.contentTableView.frame)")
        
        print("self.mainScrollView.contentSize.height: \(self.mainScrollView.contentSize.height)")
        print("\(self.mainScrollView.frame)")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        self.mainScrollView.backgroundColor = UIColor.blueColor()
        self.contentTableView.backgroundColor = UIColor.redColor()
        self.contentTableView.scrollEnabled = false
    }
    
}

extension HomeNearestViewController {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CouponCollectionTableViewCell
        cell.backgroundColor = UIColor.greenColor()
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let collectionCell = cell as! CouponCollectionTableViewCell
        collectionCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, index: indexPath.row)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 222
    }
    
}

extension HomeNearestViewController {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension HomeNearestViewController:UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
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
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    }
}


