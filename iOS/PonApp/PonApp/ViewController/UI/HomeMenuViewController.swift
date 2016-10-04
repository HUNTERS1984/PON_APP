//
//  HomeMenuViewController.swift
//  PonApp
//
//  Created by HaoLe on 9/6/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class HomeMenuViewController: BaseViewController {

    @IBOutlet weak var couponTypeTableView: UITableView!
    
    var categories = [Category]() {
        didSet {
            self.couponTypeTableView.reloadData()
            if categories.count > 0 {
                self.couponTypeTableView.hidden = false
            }else {
                self.couponTypeTableView.hidden = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        self.title = "ショップの追加"
        self.showCloseButton()
        self.couponTypeTableView.hidden = true
        self.getNumberOfShopByCouponType(1)
    }

}

extension HomeMenuViewController {
    
    private func getNumberOfShopByCouponType(pageIndex: Int) {
        self.showHUD()
        ApiRequest.getNumberOfShopByCategory(pageIndex: 1) { (request: NSURLRequest?, result: ApiResponse?, error: NSError?) in
            self.hideHUD()
            if let _ = error {
                
            }else {
                if result?.code == SuccessCode {
                    var responseCouponType = [Category]()
                    let couponTypeArray = result?.data?.array
                    if let _ = couponTypeArray {
                        for couponTypeData in couponTypeArray! {
                            let couponType = Category(response: couponTypeData)
                            responseCouponType.append(couponType)
                        }
                        self.categories = responseCouponType
                    }
                }else {
                    
                }
            }
        }
    }
    
}

extension HomeMenuViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ShopCountTableViewCell") as! ShopCountTableViewCell
        cell.setDataForCell(self.categories[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 72
    }
    
}

extension HomeMenuViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let selectedType = self.categories[indexPath.row]
        let vc = ListShopViewController.instanceFromStoryBoard("ListShop") as! ListShopViewController
        vc.couponType = selectedType.categoryID
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
