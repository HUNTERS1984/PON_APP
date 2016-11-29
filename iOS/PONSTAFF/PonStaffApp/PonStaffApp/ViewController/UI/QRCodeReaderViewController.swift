//
//  QRCodeReaderViewController.swift
//  PonStaffApp
//
//  Created by HaoLe on 10/25/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeReaderViewController: BaseViewController {

    let scanner = QRCode()
    var confirmPopup: ConfirmPopupView!
    var acceptPopup: AcceptPopupView!
    var rejectPopup: RejectPopupView!
    var code: String? = nil
    
    @IBOutlet weak var focusView: UIView!
    @IBOutlet weak var flashlightButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.startScan()
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        self.showBackButton()
        self.title = "QRリーダー"
        self.setupQRCodeReaser()
        self.setupConfirmPopupView()
        self.setupRejectPopupView()
        self.setupAcceptPopupView()
        
        self.flashlightButton.layer.cornerRadius = 45/2
        self.flashlightButton.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.flashlightButton.setImage(UIImage(named: "ic_flash"), for: .normal)
    }
    
}

extension QRCodeReaderViewController {
    
    fileprivate func setupQRCodeReaser() {
        self.focusView.backgroundColor = UIColor.clear
        self.focusView.layer.cornerRadius = 20.0
        self.focusView.layer.borderColor = UIColor.white.cgColor
        self.focusView.layer.borderWidth = 10.0
        
        scanner.prepareScan(view) { [weak self] stringValue in
            print(stringValue)
            self?.code = stringValue
            self?.confirmPopup.showPopup(inView: self!.view, animated: true)
        }
        scanner.scanFrame = view.bounds
    }
    
    fileprivate func startScan() {
        scanner.startScan()
    }
    
    func toggleTorch() {
        guard let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) else { return }
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                if device.torchMode == .on {
                    device.torchMode = .off
                } else {
                    device.torchMode = .on
                }
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
    
}

//MARK: IBAction

extension QRCodeReaderViewController {
    
    @IBAction func flashlightButtonPressed(_ sender: AnyObject) {
        self.toggleTorch()
    }
}

//MARK: Private

extension QRCodeReaderViewController {
    
    @IBAction func qrCodeButtonPressed(_ sender: AnyObject) {
        let vc = QRCodeReaderViewController.instanceFromStoryBoard("Main")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func setupConfirmPopupView() {
        self.confirmPopup = ConfirmPopupView.create()
        
        self.confirmPopup.acceptButtonPressed = { [weak self] in
            self?.confirmPopup.hidePopup()
            if let _ = self?.code {
                self?.acceptCoupon(self!.code!)
            }
        }
        
        self.confirmPopup.rejectButtonPressed = { [weak self] in
            self?.confirmPopup.hidePopup()
            if let _ = self?.code {
                self?.rejectCoupon(self!.code!)
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
