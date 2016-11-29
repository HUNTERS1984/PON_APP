//
//  RequestCouponViewController.swift
//  PonStaffApp
//
//  Created by HaoLe on 10/25/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class RequestCouponViewController: BaseViewController {

    @IBOutlet weak var couponListView: UITableView!
    
    var confirmPopup: ConfirmPopupView!
    var acceptPopup: AcceptPopupView!
    var rejectPopup: RejectPopupView!
    var coupons = [Coupon]()
    var selectedCoupon: Coupon?
    
    //paging
    var canLoadMore: Bool = true
    var currentPage: Int = 1
    var totalPage: Int!
    var nextPage: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        self.showMenuButton()
        self.showQRButton()
        self.title = "クーポンんリクエスト"
        couponListView.estimatedRowHeight = 75
        couponListView.tableFooterView = UIView()
        self.setupConfirmPopupView()
        self.setupRejectPopupView()
        self.setupAcceptPopupView()
        self.getRequestCouponList(withPage: currentPage)
    }

}

extension RequestCouponViewController {
    
    func showQRButton() {
        let button = UIBarButtonItem(image: UIImage(named: "ic_qrcode_cam"), style: .plain, target: self, action: #selector(self.qrCodeButtonPressed(_: )))
        self.navigationItem.rightBarButtonItem = button
    }
}

//MARK: IBAction

extension RequestCouponViewController {
    
    @IBAction func qrCodeButtonPressed(_ sender: AnyObject) {
        let vc = QRCodeReaderViewController.instanceFromStoryBoard("Main")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}

//MARK: Private

extension RequestCouponViewController {
    
    func setupConfirmPopupView() {
        self.confirmPopup = ConfirmPopupView.create()
        self.confirmPopup.acceptButtonPressed = { [weak self] in
            self?.confirmPopup.hidePopup()
            if let _ = self?.selectedCoupon {
                self?.acceptCoupon(self!.selectedCoupon!.code)
            }
        }
        
        self.confirmPopup.rejectButtonPressed = { [weak self] in
            self?.confirmPopup.hidePopup()
            if let _ = self?.selectedCoupon {
                self?.rejectCoupon(self!.selectedCoupon!.code)
            }
        }
    }
    
    func setupAcceptPopupView() {
        self.acceptPopup = AcceptPopupView.create()
        self.acceptPopup.doneButtonPressed = { [weak self] in
            self?.acceptPopup.hidePopup()
        }
    }
    
    func setupRejectPopupView() {
        self.rejectPopup = RejectPopupView.create()
        self.rejectPopup.doneButtonPressed = { [weak self] in
            self?.rejectPopup.hidePopup()
        }
    }
    
    fileprivate func getRequestCouponList(withPage pageIndex:Int) {
        self.showHUD()
        ApiRequest.getRequestCoupon(pageIndex: pageIndex) { (request: URLRequest?, result: ApiResponse?, error: NSError?) in
            self.hideHUD()
            if let _ = error {

            }else {
                if let _ = result {
                    if result!.code == SuccessCode {
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
                    }else {

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
            self.couponListView.reloadData()
            break
        case .loadMore:
            self.coupons.append(contentsOf: coupons)
            self.couponListView.reloadData()
            break
        case .reload:
            break
        }
    }
    
    fileprivate func acceptCoupon(_ code: String) {
        self.showHUD()
        ApiRequest.acceptCoupon(code) { (request: URLRequest?, result: ApiResponse?, error: NSError?) in
            self.hideHUD()
            if let _ = error {
                
            }else {
                if let _ = result {
                    if result!.code == SuccessCode {
                        self.acceptPopup.showPopup(inView: self.view, animated: true)
                    }else {
                        self.presentAlert(message: (result?.message)!)
                    }
                }
            }
        }
    }
    
    fileprivate func rejectCoupon(_ code: String) {
        self.showHUD()
        ApiRequest.rejectCoupon(code) { (request: URLRequest?, result: ApiResponse?, error: NSError?) in
            self.hideHUD()
            if let _ = error {
                
            }else {
                if let _ = result {
                    if result!.code == SuccessCode {
                        self.rejectPopup.showPopup(inView: self.view, animated: true)
                    }else {
                        self.presentAlert(message: (result?.message)!)
                    }
                }
            }
        }
    }
    
}

//MARK: UITableViewDataSource, UITableViewDelegate

extension RequestCouponViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.coupons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestCouponCell") as! RequestCouponCell
        let coupon = self.coupons[indexPath.row]
        cell.coupon = coupon
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selectedCoupon = self.coupons[indexPath.row]
        self.confirmPopup.showPopup(inView: self.view, animated: true)
    }
}

//MARK: - UIScrollViewDelegate
extension RequestCouponViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.currentPage == self.totalPage {
            return
        }
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height && canLoadMore {
            canLoadMore = false
            self.getRequestCouponList(withPage: self.nextPage)
        }
    }
    
}

