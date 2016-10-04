//
//  CouponCollectionTableViewCell.swift
//  PonApp
//
//  Created by HaoLe on 9/9/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

typealias MoreButtonPressed = (_ sender: AnyObject) -> ()

class CouponCollectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var couponCollectionView: HorizontalCollectionView!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    
    var moreButtonCallback: MoreButtonPressed? = nil
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupTableViewCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupTableViewCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupTableViewCell() {
        self.backgroundColor = UIColor(hex: 0xf8f8fa)
        let myCellNib = UINib(nibName: "CouponCollectionViewCell", bundle: nil)
        couponCollectionView.register(myCellNib, forCellWithReuseIdentifier: "CouponCollectionViewCell")
    }
    
    func setCollectionViewDelegate(delegate: HorizontalCollectionViewDelegate, index: NSInteger, couponListData: CouponListData) {
        self.headerLabel.text = couponListData.categoryName
        self.couponCollectionView.handler = delegate
        self.couponCollectionView.coupons = couponListData.coupons
    }
    
    @IBAction func moreButtonPressed(_ sender: AnyObject) {
        if let _ = moreButtonCallback {
            moreButtonCallback!(sender)
        }
    }

}
