//
//  AlbumCollectionViewCell.swift
//  PonApp
//
//  Created by HaoLe on 9/15/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit
import AlamofireImage

class AlbumCollectionViewCell: UICollectionViewCell {
    let downloader = ImageDownloader()
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var moreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setImage(withURL url: String?, _ isShowMore: Bool = false, _ numbersImage: Int = 0) {
        if isShowMore {
            self.moreLabel.isHidden = false
            self.moreLabel.text = "もっと見る\n+\(numbersImage)"
            self.moreLabel.backgroundColor = UIColor(red: 40.0/255.0, green: 60.0/255.0, blue: 80.0/255.0, alpha: 0.9)
        }else {
            self.moreLabel.isHidden = true
        }
        
        if let _ = url {
            let urlRequest = URLRequest(url: URL(string: url!)!)
            downloader.download(urlRequest) { response in
                if let image = response.result.value {
                    var imageHeight = image.size.height * image.scale
                    var imageWidth = image.size.width * image.scale
                    
                    if imageHeight > imageWidth {
                        imageHeight = imageWidth
                    }
                    else {
                        imageWidth = imageHeight
                    }
                    
                    let size = CGSize(width: imageWidth, height: imageHeight)
                    
                    let refWidth : CGFloat = CGFloat(image.cgImage!.width)
                    let refHeight : CGFloat = CGFloat(image.cgImage!.height)
                    
                    let x = (refWidth - size.width) / 2
                    let y = (refHeight - size.height) / 2
                    
                    let cropRect = CGRect(x: x, y: y, width: size.width, height: size.height)
                    if let imageRef = image.cgImage!.cropping(to: cropRect) {
                        self.thumbImageView.image =  UIImage(cgImage: imageRef, scale: 0, orientation: image.imageOrientation)
                    }
                }
            }
        }
    }

}
