//
//  ShowQRCodeViewController.swift
//  PonApp
//
//  Created by HaoLe on 9/29/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class ShowQRCodeViewController: BaseViewController {
    
    @IBOutlet weak var qrCodeView: UIView!
    @IBOutlet weak var qrCodeDisplayImageView: UIImageView!
    
    let scanner = QRCode()
    open var code: String?
    
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
        self.view.backgroundColor = UIColor.white
        super.setUpUserInterface()
        if let _ = self.code {
            self.qrCodeDisplayImageView.image = QRCode.generateImage(self.code!, avatarImage: nil, avatarScale: 0.3)
        }
    }
    
}

//MARK: - IBAction
extension ShowQRCodeViewController {
    
    @IBAction func closeButttonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true)
    }
    
    @IBAction func qrCodePressed(_ sender: AnyObject) {
        
    }
    
}

//MARK: - Private method
extension ShowQRCodeViewController {
    
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
