//
//  QRCodeReaderViewController.swift
//  PonStaffApp
//
//  Created by HaoLe on 10/25/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class QRCodeReaderViewController: BaseViewController {

    let scanner = QRCode()
    @IBOutlet weak var focusView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.startScan()
        
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        self.showBackButton()
        self.title = "QR READER"
        self.setupQRCodeReaser()
    }
    
}

extension QRCodeReaderViewController {
    
    fileprivate func setupQRCodeReaser() {
        self.focusView.backgroundColor = UIColor.clear
        self.focusView.layer.cornerRadius = 20.0
        self.focusView.layer.borderColor = UIColor.white.cgColor
        self.focusView.layer.borderWidth = 10.0
        
        scanner.prepareScan(view) { (stringValue) -> () in
            print(stringValue)
        }
        scanner.scanFrame = view.bounds
    }
    
    fileprivate func startScan() {
        scanner.startScan()
    }
    
}
