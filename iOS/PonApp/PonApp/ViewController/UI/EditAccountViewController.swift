//
//  EditAccountViewController.swift
//  PonApp
//
//  Created by HaoLe on 9/5/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class EditAccountViewController: BaseViewController {
    
    @IBOutlet weak var genderDropdown: IQDropDownTextField!
    @IBOutlet weak var perfectureDropdown: IQDropDownTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func setUpComponentsOnLoad() {
        super.setUpComponentsOnLoad()
    }
    
    override func setUpUserInterface() {
        super.setUpUserInterface()
        self.title = "プロフィール編集"
        self.showBackButton()
        self.setupGenderDropdown()
        self.setupPerfectureDropdown()
    }
}

//MARK: - IBAction
extension EditAccountViewController {
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        
    }
    
    @IBAction func editAvatarButtonPressed(sender: AnyObject) {
        
    }
    
}

//MARK: - Private
extension EditAccountViewController {
    
    private func setupGenderDropdown() {
        genderDropdown.keyboardDistanceFromTextField = 50
        genderDropdown.delegate = self
        genderDropdown.itemList = [
            "男性",
            "女人"
        ]
    }
    
    private func setupPerfectureDropdown() {
        perfectureDropdown.keyboardDistanceFromTextField = 50
        perfectureDropdown.delegate = self
        perfectureDropdown.itemList = [
            "男性",
            "女人"
        ]
    }
    
}

//MARK: - HLKDropDownTextFieldDelegate
extension EditAccountViewController: IQDropDownTextFieldDelegate {
    
    func textField(textField: IQDropDownTextField!, didSelectItem item: String!) {
        
    }
    
}
