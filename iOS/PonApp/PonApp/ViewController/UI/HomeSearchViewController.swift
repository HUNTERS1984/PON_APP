//
//  HomeSearchViewController.swift
//  PonApp
//
//  Created by HaoLe on 9/5/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class HomeSearchViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

}

//MARK: - IBAction
extension HomeSearchViewController {
    
    @IBAction func locationButtonPressed(sender: AnyObject) {
        let vc = HomeMapViewController.instanceFromStoryBoard("MainMenu")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
