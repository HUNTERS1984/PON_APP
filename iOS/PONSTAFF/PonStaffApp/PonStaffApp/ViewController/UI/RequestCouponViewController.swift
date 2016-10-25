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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        self.showMenuButton()
        self.showQRButton()
        self.title = "COUPON REQUEST"
        couponListView.estimatedRowHeight = 75
    }

}

extension RequestCouponViewController {
    
    func showQRButton() {
        let button = UIBarButtonItem(image: UIImage(named: "nav_qr"), style: .plain, target: self, action: #selector(self.qrCodeButtonPressed(_: )))
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
    }
}
