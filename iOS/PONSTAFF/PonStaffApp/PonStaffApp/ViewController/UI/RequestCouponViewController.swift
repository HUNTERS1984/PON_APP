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
        self.title = "COUPON REQUEST"
        couponListView.estimatedRowHeight = 75
        self.setupConfirmPopupView()
        self.setupRejectPopupView()
        self.setupAcceptPopupView()
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
        
        self.confirmPopup.popupDidShowCallback = {
            
        }
        
        self.confirmPopup.popupDidHideCallback = {
            
        }
        
        self.confirmPopup.acceptButtonPressed = {
            self.confirmPopup.hidePopup()
            self.acceptPopup.showPopup(inView: self.view, animated: true)
        }
        
        self.confirmPopup.rejectButtonPressed = {
            self.confirmPopup.hidePopup()
            self.rejectPopup.showPopup(inView: self.view, animated: true)
        }
    }
    
    func setupAcceptPopupView() {
        self.acceptPopup = AcceptPopupView.create()
        
        self.acceptPopup.popupDidShowCallback = {
            
        }
        
        self.acceptPopup.popupDidHideCallback = {
            
        }
        
        self.acceptPopup.doneButtonPressed = {
            self.acceptPopup.hidePopup()
        }
    }
    
    func setupRejectPopupView() {
        self.rejectPopup = RejectPopupView.create()
        
        self.rejectPopup.popupDidShowCallback = {
            
        }
        
        self.rejectPopup.popupDidHideCallback = {
            
        }
        
        self.rejectPopup.doneButtonPressed = {
            self.rejectPopup.hidePopup()
        }
    }
    
}

//MARK: UITableViewDataSource, UITableViewDelegate

extension RequestCouponViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestCouponCell") as! RequestCouponCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.confirmPopup.showPopup(inView: self.view, animated: true)
    }
}
