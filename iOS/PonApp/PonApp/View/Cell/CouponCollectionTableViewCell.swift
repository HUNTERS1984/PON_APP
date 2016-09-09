//
//  CouponCollectionTableViewCell.swift
//  PonApp
//
//  Created by HaoLe on 9/9/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class CouponCollectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var couponCollectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCollectionViewDataSourceDelegate(dataSourceDelegate delegate: protocol<UICollectionViewDelegate,UICollectionViewDataSource>, index: NSInteger) {
        self.couponCollectionView.dataSource = delegate
        self.couponCollectionView.delegate = delegate
        self.couponCollectionView.tag = index
        self.couponCollectionView.reloadData()
    }

}
