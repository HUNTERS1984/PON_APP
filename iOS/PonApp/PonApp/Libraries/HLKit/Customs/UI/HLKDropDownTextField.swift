//
//  HLKDropDownTextField.swift
//  Test
//
//  Created by HaoLe on 7/21/16.
//  Copyright © 2016 EW. All rights reserved.
//

import UIKit

struct HLKDropDownItem {
    var itemId: Float!
    var itemTitle: String!
    var isAvailable: Bool = true
    
    init(itemId: Float, itemTitle: String, isAvailable: Bool? = nil) {
        self.itemId = itemId
        self.itemTitle = itemTitle
        if let isAvailable = isAvailable {
            self.isAvailable = isAvailable
        }
    }
}

protocol HLKDropDownTextFieldDelegate: class {
    
    func dropDownTextField(dropdown: HLKDropDownTextField, didSelectItem item: HLKDropDownItem, atIndex index: Int)
    func dropDownTextFieldShouldBeginEditing(dropdown: HLKDropDownTextField)
}

class HLKDropDownTextField: UITextField {
    
    private var padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5)
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.CGColor
        }
    }
    
    var itemList: [HLKDropDownItem] = [HLKDropDownItem]() {
        didSet {
            pickerView.reloadAllComponents()
        }
    }
    var selectedItem: HLKDropDownItem?
    var placeHolderText: String = "Tap to choose..." {
        didSet {
            layoutTextField()
        }
    }
    var placeholderWhileSelecting: String = "Pick an option..." {
        didSet {
            layoutTextField()
        }
    }
    private var pickerView:UIPickerView!
    weak var handler: HLKDropDownTextFieldDelegate? = nil
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    func initialize() {
        self.valueForKey("textInputTraits")?.setValue(UIColor.clearColor(), forKey: "insertionPointColor")
        self.delegate = self
        self.placeholder = placeHolderText
        
        pickerView = UIPickerView()
        pickerView.showsSelectionIndicator = true
        pickerView.dataSource = self
        pickerView.delegate = self
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpaceLeft = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(HLKDropDownTextField.doneButtonPressed(_:)))
        toolbar.setItems([flexibleSpaceLeft, doneButton], animated: false)
        self.inputView = pickerView
        self.inputAccessoryView = toolbar
    }
    
    func resetDropdown() {
        self.selectedItem = nil
        self.text = ""
        self.placeholder = placeHolderText
    }
    
}

//MARK: - Override Methods
extension HLKDropDownTextField {
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return super.textRectForBounds(UIEdgeInsetsInsetRect(bounds, padding))
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return super.editingRectForBounds(UIEdgeInsetsInsetRect(bounds, padding))
    }
}

//MARK: - Private Methods
extension HLKDropDownTextField {
    
    private func layoutTextField() {
        self.placeholder = placeHolderText
    }
    
    private func selectedItemIndex(selectedItem: HLKDropDownItem) -> Int {
        for index in 0 ..< itemList.count {
            let item = itemList[index] as HLKDropDownItem
            if item.itemId == selectedItem.itemId {
                return index
            }
        }
        return 0
    }
    
}

//MARK: - IBAction
extension HLKDropDownTextField {
    
    @IBAction func showDropdownMenu(sender: AnyObject) {
        if self.text!.characters.count == 0 {
            self.placeholder = placeholderWhileSelecting
        }else{
            pickerView.selectRow(selectedItemIndex(selectedItem!), inComponent: 0, animated: false)
        }
    }
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        resignFirstResponder()
    }
    
}

//MARK: - UITextFieldDelegate
extension HLKDropDownTextField: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        showDropdownMenu(textField)
        handler?.dropDownTextFieldShouldBeginEditing(self)
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
}

//MARK: - UIPickerViewDataSource
extension HLKDropDownTextField: UIPickerViewDataSource {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if itemList.count > 0 {
            return itemList.count
        }
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if itemList.count > 0 {
            let item = itemList[row] as HLKDropDownItem
            return item.itemTitle
        }
        return ""
    }
    
}

//MARK: - UIPickerViewDelegate
extension HLKDropDownTextField: UIPickerViewDelegate {
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let item = itemList[row]
        self.text = item.itemTitle
        self.selectedItem = item
        handler?.dropDownTextField(self, didSelectItem: item, atIndex: row)
    }
    
}