//
//  CouponCollectionTableViewCell.swift
//  PonApp
//
//  Created by HaoLe on 9/9/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

typealias MoreButtonPressed = (sender: AnyObject) -> ()

class CouponCollectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var couponCollectionView: UICollectionView!
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

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupTableViewCell() {
        let myCellNib = UINib(nibName: "CouponCollectionViewCell", bundle: nil)
        couponCollectionView.registerNib(myCellNib, forCellWithReuseIdentifier: "CouponCollectionViewCell")
    }
    
    func setCollectionViewDataSourceDelegate(dataSourceDelegate delegate: protocol<UICollectionViewDelegate,UICollectionViewDataSource>, index: NSInteger) {
        self.couponCollectionView.dataSource = delegate
        self.couponCollectionView.delegate = delegate
        self.couponCollectionView.tag = index
        self.couponCollectionView.reloadData()
    }
    
    @IBAction func moreButtonPressed(sender: AnyObject) {
        if let _ = moreButtonCallback {
            moreButtonCallback!(sender: sender)
        }
    }

}
