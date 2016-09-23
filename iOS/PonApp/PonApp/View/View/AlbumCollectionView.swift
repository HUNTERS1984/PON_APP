//
//  AlbumCollectionView.swift
//  PonApp
//
//  Created by HaoLe on 9/15/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

class AlbumCollectionView: UICollectionView {

    var photos = [String] ()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.initialize()
    }
    
    func initialize() {
        self.dataSource = self
        self.delegate = self
        let myCellNib = UINib(nibName: "AlbumCollectionViewCell", bundle: nil)
        self.registerNib(myCellNib, forCellWithReuseIdentifier: "AlbumCollectionViewCell")
    }

}

//MARK: - UICollectionViewDataSource
extension AlbumCollectionView: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.photos.count > 9 {
            return 9
        }else {
            return self.photos.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AlbumCollectionViewCell", forIndexPath: indexPath) as! AlbumCollectionViewCell
        let URL = NSURL(string: self.photos[indexPath.item])!
        cell.thumbImageView.af_setImageWithURL(URL)
        return cell
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let commentView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "AlbumCollectionViewCell", forIndexPath: indexPath) as! AlbumCollectionViewCell
        return commentView
    }
    
}

//MARK: - UICollectionViewDelegate
extension AlbumCollectionView: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension AlbumCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let picDimension = (self.frame.size.width - 40) / 3.0
        return CGSizeMake(picDimension, picDimension)
    }
    
}