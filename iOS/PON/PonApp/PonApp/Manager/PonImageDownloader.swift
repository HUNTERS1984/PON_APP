//
//  ImageDownloader.swift
//  HappyAppSynova
//
//  Created by HaoLe on 12/6/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire


typealias ImageDownloaderCompletion = (_ result: UIImage?, _ error: NSError?) -> Void
typealias GetCachedCompletion = (_ image: UIImage) -> Void

class PonImageDownloader{

    let downloader = ImageDownloader()
    
    class var shared: PonImageDownloader {
        struct Static {
            static let instance = PonImageDownloader()
        }
        return Static.instance
    }
    
    var data = [DownloaderData]()

    func downloadImage(_ imageUrl: String, completion: @escaping(ImageDownloaderCompletion)) {
        //check if image exist
        let cachedImage = self.getCachedImage(imageUrl)
        if let _ = cachedImage {
            completion(cachedImage, nil)
        }else {
            completion(nil, nil)
        }
        downloader.download(URLRequest(url: URL(string: imageUrl)!)) { response in
            let url = response.request!.url!.absoluteString
            let image = response.result.value
            print("downloaded image at url: " + url)
            self.data.append(DownloaderData(url: url, image: image))
            if let _ = image {
                completion(image, nil)
            }else {
                completion(nil, nil)
            }
        }
    }
    
    func getImage(_ url: String) -> UIImage {
        for cachedImage in self.data {
            if cachedImage.url == url {
                if let _ = cachedImage.image {
                    return cachedImage.image!
                }else {
                    return UIImage()
                }
            }
        }
        return UIImage()
    }
    
    func getCachedImage(_ url: String) -> UIImage? {
        for cachedImage in self.data {
            if cachedImage.url == url {
                if let _ = cachedImage.image {
                    return cachedImage.image!
                }else {
                    return nil
                }
            }
        }
        return nil
    }
    
    func getCachedImage(_ url: String, completion: @escaping(GetCachedCompletion)) {
        let img = self.getCachedImage(url)
        if let _ = img {
            completion(img!)
        }else {
            let urlRequest = URLRequest(url: URL(string: url)!)
            downloader.download(urlRequest) { response in
                let url = response.request!.url!.absoluteString
                let image = response.result.value
                print("downloaded image at url: " + url)
                self.data.append(DownloaderData(url: url, image: image))
                if let _ = image {
                    completion(image!)
                }else {
                    completion(UIImage())
                }
            }
        }
    }
   
}

struct DownloaderData {
    
    var url: String!
    var image: UIImage?
    
    init(url: String!, image: UIImage?) {
        self.url = url
        self.image = image
    }
    
}

        
