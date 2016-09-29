//
//  ScanQRCodeViewController.swift
//  PonApp
//
//  Created by HaoLe on 9/9/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit
import SwiftQRCode

class ScanQRCodeViewController: BaseViewController {

    @IBOutlet weak var qrCodeView: UIView!
    @IBOutlet weak var qrCodeDisplayImageView: UIImageView!
    
    let scanner = QRCode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        self.qrCodeDisplayImageView.image = QRCode.generateImage("Hello SwiftQRCode", avatarImage: nil, avatarScale: 0.3)
    }

}

//MARK: - IBAction
extension ScanQRCodeViewController {
    
    @IBAction func closeButttonPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(false)
    }
    
    @IBAction func qrCodePressed(sender: AnyObject) {

        
    }
    
}

//MARK: - Private method
extension ScanQRCodeViewController {
    
    private func setupQRCodeView() {
        self.qrCodeView.clipsToBounds = true
        self.qrCodeView.layer.cornerRadius = 4.0
        self.qrCodeView.layer.borderColor = UIColor(hex: 0xcad5d9).CGColor
        self.qrCodeView.layer.borderWidth = 1.0
        scanner.prepareScan(self.qrCodeView) { (stringValue) -> () in
            print(stringValue)
        }
        scanner.scanFrame = self.qrCodeView.bounds
    }
    
}