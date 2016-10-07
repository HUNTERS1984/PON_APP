//
//  ScanQRCodeViewController.swift
//  PonApp
//
//  Created by HaoLe on 9/9/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        self.view.backgroundColor = UIColor.white
        self.qrCodeDisplayImageView.image = QRCode.generateImage("Hello SwiftQRCode", avatarImage: nil, avatarScale: 0.3)
    }

}

//MARK: - IBAction
extension ScanQRCodeViewController {
    
    @IBAction func closeButttonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true)
    }
    
    
}

//MARK: - Private method
extension ScanQRCodeViewController {
    
    fileprivate func setupQRCodeView() {
        self.qrCodeView.clipsToBounds = true
        self.qrCodeView.layer.cornerRadius = 4.0
        self.qrCodeView.layer.borderColor = UIColor(hex: 0xcad5d9).cgColor
        self.qrCodeView.layer.borderWidth = 1.0
        scanner.prepareScan(self.qrCodeView) { (stringValue) -> () in
            print(stringValue)
        }
        scanner.scanFrame = self.qrCodeView.bounds
    }
    
}
