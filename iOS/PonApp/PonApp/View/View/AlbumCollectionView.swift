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
        self.register(myCellNib, forCellWithReuseIdentifier: "AlbumCollectionViewCell")
    }

}

//MARK: - UICollectionViewDataSource
extension AlbumCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.photos.count > 9 {
            return 9
        }else {
            return self.photos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCollectionViewCell", for: indexPath) as! AlbumCollectionViewCell
        let URL = Foundation.URL(string: self.photos[(indexPath as NSIndexPath).item])!
        cell.thumbImageView.af_setImage(withURL: URL)
        return cell
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let commentView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "AlbumCollectionViewCell", for: indexPath) as! AlbumCollectionViewCell
        return commentView
    }
    
}

//MARK: - UICollectionViewDelegate
extension AlbumCollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension AlbumCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let picDimension = (self.frame.size.width - 60) / 3.0
        return CGSize(width: picDimension, height: picDimension)
    }
    
}
