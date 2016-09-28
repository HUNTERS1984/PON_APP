//
//  EditAccountViewController.swift
//  PonApp
//
//  Created by HaoLe on 9/5/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit
import Photos
import AVKit
import DKImagePickerController

class EditAccountViewController: BaseViewController {
    
    @IBOutlet weak var genderDropdown: IQDropDownTextField!
    @IBOutlet weak var addressDropdown: IQDropDownTextField!
    @IBOutlet weak var avatarImageView: CircleImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
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
        self.setupAddressDropdown()
    }
    
    override func setUpComponentsOnWillAppear() {
        super.setUpComponentsOnWillAppear()
        self.displayUserInfo()
    }
}

//MARK: - IBAction
extension EditAccountViewController {
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        let username = self.nameTextField.text
        let gender = self.genderDropdown.text
        let address = self.addressDropdown.text
        let avatar = self.avatarImageView.image
        self.validInfomation(username, gender: gender, address: address) { (successed: Bool, message: String) in
            if successed {
                self.showHUD()
                ApiRequest.updateUserProfile(username, gender:self.getGender(gender), address: address, avatar: avatar, completion: { (request: NSURLRequest?, result: ApiResponse?, error: NSError?) in
                    self.hideHUD()
                    if let _ = error {
                        
                    }else {
                        if result?.code == SuccessCode {
                            self.navigationController?.popViewControllerAnimated(true)
                        }
                    }
                })
            }else {
                
            }
        }
    }
    
    @IBAction func editAvatarButtonPressed(sender: AnyObject) {
        showImagePickerWithAssetType(.AllPhotos) { (assets: [DKAsset]) in
            if assets.count > 0 {
                let asset = assets[0]
                asset.fetchOriginalImageWithCompleteBlock({ (image: UIImage?, info: [NSObject : AnyObject]?) in
                    self.avatarImageView.image = image
                })
            }
        }
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
    
    private func setupAddressDropdown() {
        addressDropdown.keyboardDistanceFromTextField = 50
        addressDropdown.delegate = self
        addressDropdown.itemList = [
            "あいちけん",
            "あきたけん",
            "あおもりけん",
            "ちばけん",
            "えひめけん",
            "ふくいけん",
            "ふくおかけん",
            "ふくしまけん",
            "ぎふけん"
        ]
    }
    
    private func getGender(gender: String?) -> Int {
        if let _ = gender {
            if gender! == "男性" {
                return 1
            }
            
            if gender! == "女人" {
                return 2
            }
        }
        return 0
    }
    
    private func converGender(gender: Int?) -> String {
        if let _ = gender {
            if gender! == 1 {
                return "男性"
            }
            
            if gender! == 2 {
                return "女人"
            }
        }
        return ""
    }
    
    private func showImagePickerWithAssetType(assetType: DKImagePickerControllerAssetType,
                                              allowMultipleType: Bool = false,
                                              sourceType: DKImagePickerControllerSourceType = .Both,
                                              singleSelect: Bool = true,
                                              didSelectAssets:(assets: [DKAsset]) -> Void) {
        
        let pickerController = DKImagePickerController()
        
        pickerController.assetType = assetType
        pickerController.allowsLandscape = false
        pickerController.allowMultipleTypes = allowMultipleType
        pickerController.sourceType = sourceType
        pickerController.singleSelect = singleSelect
        
        pickerController.didSelectAssets = didSelectAssets
        
        if UI_USER_INTERFACE_IDIOM() == .Pad {
            pickerController.modalPresentationStyle = .FormSheet
        }
        
        self.presentViewController(pickerController, animated: true) {}
    }
    
    private func validInfomation(userName: String?, gender: String?, address: String?, completion:(successed: Bool, message: String) -> Void) {
        if let _ = userName {
            
        }else {
            completion(successed: false, message: "Please enter user name")
        }
        
        if let _ = gender {
            
        }else {
            completion(successed: false, message: "Please enter gender")
        }
        
        if let _ = address {
            
        }else {
            completion(successed: false, message: "Please enter address")
        }
        completion(successed: true, message: "")
    }
    
    private func displayUserInfo() {
        if let _ = UserDataManager.sharedInstance.name {
            self.nameTextField.text = UserDataManager.sharedInstance.name!
        }else {
            self.nameTextField.text = ""
        }
        
        if let _ = UserDataManager.sharedInstance.avatarUrl {
            let avatarUrl = NSURL(string: UserDataManager.sharedInstance.avatarUrl!)
            self.avatarImageView.af_setImageWithURL(avatarUrl!)
        }else {
            self.avatarImageView.image = UIImage(named: "account_avatar_placehoder")
        }
        
        if let _ = UserDataManager.sharedInstance.email {
            self.emailTextField.text = UserDataManager.sharedInstance.email!
        }else {
            self.emailTextField.text = ""
        }
        
        if let _ = UserDataManager.sharedInstance.gender {
            self.genderDropdown.text = self.converGender(UserDataManager.sharedInstance.gender!)
        }else {
            self.genderDropdown.text = ""
        }
        
        if let _ = UserDataManager.sharedInstance.address {
            self.addressDropdown.text = UserDataManager.sharedInstance.address!
        }else {
            self.addressDropdown.text = ""
        }
    }
    
}

//MARK: - HLKDropDownTextFieldDelegate
extension EditAccountViewController: IQDropDownTextFieldDelegate {
    
    func textField(textField: IQDropDownTextField!, didSelectItem item: String!) {
        
    }
    
}
