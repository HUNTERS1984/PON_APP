//
//  HomeMapViewController.swift
//  PonApp
//
//  Created by HaoLe on 9/5/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class HomeMapViewController: BaseViewController {

    @IBOutlet weak var offerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuButton: DesignableButton!
    @IBOutlet weak var hideOfferButton: DesignableButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        self.offerViewBottomConstraint.constant -= 172
        self.hideOfferButton.hidden = true
        self.menuButton.hidden = false
    }

}

//MARK: - IBAction
extension HomeMapViewController {
    
    @IBAction func currentLocationButtonPressed(sender: AnyObject) {
        self.showOfferView()
    }
    
    @IBAction func menuButtonPressed(sender: AnyObject) {
        let vc = HomeMenuViewController.instanceFromStoryBoard("MainMenu")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func hideOfferButtonPressed(sender: AnyObject) {
        self.hideOfferView()
    }
    
}

//MARK: - Private Methods
extension HomeMapViewController {
    
    private func showOfferView() {
        self.offerViewBottomConstraint.constant += 172
        self.hideOfferButton.hidden = false
        self.menuButton.hidden = true
    }
    
    private func hideOfferView() {
        self.offerViewBottomConstraint.constant -= 172
        self.hideOfferButton.hidden = true
        self.menuButton.hidden = false
    }
    
}