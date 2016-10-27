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
        self.title = "QR READER"
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
        
        scanner.prepareScan(view) { (stringValue) -> () in
            print(stringValue)
            self.confirmPopup.showPopup(inView: self.view, animated: true)
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
