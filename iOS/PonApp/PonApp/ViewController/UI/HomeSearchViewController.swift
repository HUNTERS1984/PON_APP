//
//  HomeSearchViewController.swift
//  PonApp
//
//  Created by HaoLe on 9/5/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class HomeSearchViewController: BaseViewController {

    @IBOutlet weak var couponTypeTableView: UITableView!
    
    var couponTypes = [CouponType]() {
        didSet {
            self.couponTypeTableView.reloadData()
            if couponTypes.count > 0 {
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "nav_search"), style: .Plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.showSearchBox()
        self.showRightBarButtonWithTitle("キャンセル")
        self.couponTypeTableView.hidden = true
        self.getCouponType(1)
    }

}

//MARK: - IBAction
extension HomeSearchViewController {
    
    @IBAction func locationButtonPressed(sender: AnyObject) {
        let vc = HomeMapViewController.instanceFromStoryBoard("MainMenu")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func rightBarButtonPressed(sender: AnyObject) {
        super.rightBarButtonPressed(sender)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}

//MARK: - Private
extension HomeSearchViewController {
    
    private func showSearchBox() {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        
        let searchBox = UITextField(frame: CGRectMake(0, 0, screenWidth - 60, 30))
        searchBox.backgroundColor = UIColor.clearColor()
        searchBox.textColor = UIColor.whiteColor()
        searchBox.font = UIFont.HiraginoSansW6(17)
        searchBox.placeholder = "地名/ショップ名を入力"
        searchBox.borderStyle = .None
        searchBox.autoresizingMask = .FlexibleWidth
        self.navigationItem.titleView = searchBox
    }
    
    private func getCouponType(pageIndex: Int) {
        self.showHUD()
        ApiRequest.getCouponType(pageIndex: 1) { (request: NSURLRequest?, result: ApiResponse?, error: NSError?) in
            self.hideHUD()
            if let _ = error {
                
            }else {
                if result?.code == SuccessCode {
                    var responseCouponType = [CouponType]()
                    let couponTypeArray = result?.data?.array
                    if let _ = couponTypeArray {
                        for couponTypeData in couponTypeArray! {
                            let couponType = CouponType(response: couponTypeData)
                            responseCouponType.append(couponType)
                        }
                        self.couponTypes = responseCouponType
                    }
                }else {
                    
                }
            }
        }
    }
    
}

extension HomeSearchViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.couponTypes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CouponTypeTableViewCell") as! CouponTypeTableViewCell
        cell.setDataForCell(self.couponTypes[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 72
    }
    
}

extension HomeSearchViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let selectedType = self.couponTypes[indexPath.row]
        let vc = ListCouponViewController.instanceFromStoryBoard("CouponList") as! ListCouponViewController
        vc.couponType = selectedType.couponTypeID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
