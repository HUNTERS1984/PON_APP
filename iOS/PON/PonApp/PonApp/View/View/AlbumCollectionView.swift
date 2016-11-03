//
//  AlbumCollectionView.swift
//  PonApp
//
//  Created by HaoLe on 9/15/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

protocol AlbumCollectionViewDelegate: class {
    func albumCollectionView(_ collectionView: AlbumCollectionView, didSelectImageAtIndex index: Int, imageUrl url:String)
}

class AlbumCollectionView: UICollectionView {

    @IBInspectable var totalMargin: CGFloat = 60
    
    var photos = [String] ()
    weak var handler: AlbumCollectionViewDelegate? = nil
    
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
        let imageURL = self.photos[indexPath.item]
        
        if self.photos.count > 9 {
            if indexPath.item < 9 {
                cell.setImage(withURL: imageURL)
            }else {
                cell.setImage(withURL: imageURL, true, self.photos.count - 9)
            }
        }else {
            cell.setImage(withURL: imageURL)
        }
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
        self.handler?.albumCollectionView(self, didSelectImageAtIndex: indexPath.item, imageUrl: self.photos[indexPath.item])
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension AlbumCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let width = (screenWidth - totalMargin) / 3.0
        return CGSize(width: width, height: width)
    }
    
}
