//
//  HLKLinearScrollView.swift
//  MassageIOS
//
//  Created by HaoLe on 7/13/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

import UIKit

struct LayoutMargin {
    
    var top: CGFloat!
    var right: CGFloat!
    var bottom: CGFloat!
    var left: CGFloat!
    
    init(top: CGFloat, right: CGFloat, bottom: CGFloat, left: CGFloat ) {
        self.top = top
        self.right = right
        self.bottom = bottom
        self.left = left
    }
    
}

class LinearLayoutItem: NSObject {
    
    var view: UIView!
    var margin: LayoutMargin!
    var contentSize: CGSize!
    
    init(view: UIView, margin: LayoutMargin, contentSize: CGSize) {
        self.view = view
        self.margin = margin
        self.contentSize = contentSize
    }
    
}

class HLKLinearScrollView: UIScrollView {
    
    //MARK: Private
    var linearLayoutSubViews = [LinearLayoutItem]()
    var originalContentSize:CGSize!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func addSubview(view: UIView, margin: LayoutMargin) {
        
        let item = LinearLayoutItem(view: view, margin: margin, contentSize: view.bounds.size)
        addItemOnVertical(item)
    }
    
    func addItemOnVertical(item: LinearLayoutItem) {
        var offSetY: CGFloat = 0
        let lastItem = self.linearLayoutSubViews.last
        
        if let lastItem = lastItem {
            offSetY = lastItem.view.frame.origin.y + lastItem.contentSize.height + lastItem.margin.bottom
        }
        
        let x = item.margin.left
        let y = item.margin.top + offSetY
        let width = item.contentSize.width
        let height = item.contentSize.height
        
        item.view.frame = CGRectMake(x, y, width, height)
        self.addSubview(item.view!)
        self.linearLayoutSubViews.append(item)
        
        //calculate contentsize for scrolling
        let contentHeight:CGFloat = y + height + item.margin.bottom
        self.contentSize = CGSizeMake(self.contentSize.width, contentHeight)
        self.originalContentSize = self.contentSize
    }
    
    func updateItemOnVertical(item:LinearLayoutItem, animated:Bool) {
        let dy = item.view.bounds.size.height - item.contentSize.height
        item.contentSize = item.view.bounds.size
        
        let indexOfItem = linearLayoutSubViews.indexOf(item)
        let startIndex = indexOfItem! + 1
        let duration = animated ? 0.5 : 0
        
        UIView.animateWithDuration(duration, animations: { () -> Void in
            for index in startIndex..<self.linearLayoutSubViews.count {
                let item = self.linearLayoutSubViews[index]
                item.view.frame = CGRectOffset(item.view.frame, 0, dy)
            }
            
        }) { (Bool) -> Void in
            let lastItem = self.linearLayoutSubViews.last
            
            if let lastItem = lastItem {
                let contentHeight = lastItem.view.frame.origin.y + lastItem.contentSize.height + lastItem.margin.bottom;
                self.contentSize = CGSizeMake(self.contentSize.width, contentHeight);
                self.originalContentSize = self.contentSize;
            }
        }
    }
    
    func updateContentSizeWithKeyboardSize(keyboardSize: CGSize, show: Bool) {
        var linearLayoutSize = self.contentSize
        if show {
            linearLayoutSize.height = linearLayoutSize.height + keyboardSize.height
            self.contentSize = linearLayoutSize
        }else{
            linearLayoutSize.height = linearLayoutSize.height - keyboardSize.height
            self.contentSize = linearLayoutSize
        }
    }
    
    func updateSizeForView(view: UIView, animated: Bool) {
        for item in self.linearLayoutSubViews {
            if item.view == view {
                updateItemOnVertical(item, animated: animated)
            }
        }
    }
    
    func wrapSubviewsToLinearLayout(numberOfTags: NSInteger, padding:CGFloat ) {
        for tag in 1...numberOfTags {
            let view = self.viewWithTag(tag)!
            let lastItem = self.linearLayoutSubViews.last
            var offSetY: CGFloat  = 0
            if let lastItem = lastItem {
                offSetY += lastItem.view.frame.origin.y + lastItem.contentSize.height + lastItem.margin.bottom
            }
            
            var bottom: CGFloat = 0
            if tag == numberOfTags {
                bottom = padding
            }
            let margin = LayoutMargin(top: view.frame.origin.y - offSetY, right: 0, bottom: bottom, left: view.frame.origin.x)
            addSubview(view, margin: margin)
        }
        
        if  self.contentSize.height < self.bounds.size.height {
            self.contentSize = self.bounds.size
            originalContentSize = self.contentSize
        }
    }
    
    func scrollToSender(sender: UIView?, keyboardSize: CGSize) {
        if let _ = sender {
            self.contentSize = CGSizeMake(self.originalContentSize.width, self.originalContentSize.height + keyboardSize.height)
            var superView = sender
            var y: CGFloat = 0.0
            
            repeat{
                y += superView!.frame.origin.y;
                superView = superView!.superview!
            }while (superView != self);
            
            y += sender!.bounds.size.height * 1.5;
            let availableHeight = self.bounds.size.height - keyboardSize.height;
            if y > availableHeight {
                let delta = y - availableHeight;
                
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.setContentOffset(CGPointMake(0, delta + sender!.bounds.size.height), animated: false)
                })
            }
        }else {
            self.contentSize = CGSizeMake(self.originalContentSize.width, self.originalContentSize.height + keyboardSize.height)
            return
        }
    }
    
    func restoreScrollView() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.contentSize = self.originalContentSize
        })
    }
    
}
