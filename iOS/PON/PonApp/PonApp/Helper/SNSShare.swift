//
//  SNSShare.swift

import Foundation
import UIKit
import Social

public enum SNSType {
    
    case twitter, facebook, line, instagram
    
    public static var list: [SNSType] {
        return [SNSType.twitter, .facebook, .line, .instagram]
    }
    
    public var serviceType: String {
        switch self {
        case .twitter: return SLServiceTypeTwitter
        case .facebook: return SLServiceTypeFacebook
        default: return ""
        }
    }
    
    public func useSocialFramework() -> Bool {
        switch self {
        case .twitter, .facebook: return true
        default: return false
        }
    }
    
}

public enum SNSShareResult {
    case success
    case failure(SNSShareErrorType)
}

public enum SNSShareErrorType: Error {
    case notAvailable(SNSType)
    case emptyData
    case cancelled
    case uriEncodingError
    case unknownError
}

public typealias SNSSharePostCompletion = (SNSShareResult) -> Void

open class SNSShareData {
    
    open var text: String = ""
    open var images: [UIImage] = [UIImage]()
    open var urls: [URL] = [URL]()
    
    public init() {
    }
    
    public init(_ text: String) {
        self.text = text
    }
    
    public init(_ images: [UIImage]) {
        self.images = images
    }
    
    public init(_ urls: [URL]) {
        self.urls = urls
    }
    
    public init(text: String, images: [UIImage], urls: [URL]) {
        self.text = text
        self.images = images
        self.urls = urls
    }
    
    public typealias BuilderClosure = (SNSShareData) -> Void
    public init(builder: BuilderClosure) {
        builder(self)
    }    
    
    open var isEmpty: Bool {
        return text.characters.isEmpty && images.isEmpty && urls.isEmpty
    }
    
}

open class SNSShare {
    
    open class func available(_ type: SNSType) -> Bool {
        switch type {
        case .twitter:
            return SLComposeViewController.isAvailable(forServiceType: SNSType.twitter.serviceType)
        case .facebook:
            return SLComposeViewController.isAvailable(forServiceType: SNSType.facebook.serviceType)
        case .line:
            return UIApplication.shared.canOpenURL(URL(string: "line://")!)
        case .instagram:
            return UIApplication.shared.canOpenURL(URL(string: "instagram://")!)
        }
    }
    
    open class func isLineInstalled() -> Bool {
        return SNSShare.available(.line)
    }
    
    open class func isInstagramInstalled() -> Bool {
        return SNSShare.available(.instagram)
    }
    
    open class func availableSNSList() -> [SNSType] {
        return SNSType.list.filter { available($0) }
    }
    
    open class func post(
        type: SNSType,
        data: SNSShareData,
        controller: UIViewController,
        completion: @escaping SNSSharePostCompletion = { _ in })
    {
        guard available(type) else {
            completion(.failure(.notAvailable(type)))
            return
        }
        
        guard !data.isEmpty else {
            completion(.failure(.emptyData))
            return
        }
        
        if type.useSocialFramework() {
            postToSocial(type.serviceType, data: data, controller: controller, completion: completion)
        } else {
            if case .line = type {
                postToLINE(data, completion: completion)
            } else {
                completion(.failure(.unknownError))
            }
        }
    }
    
    fileprivate class func postToSocial(
        _ serviceType: String,
        data: SNSShareData,
        controller: UIViewController,
        completion: @escaping SNSSharePostCompletion)
    {
        let sheet = SLComposeViewController(forServiceType: serviceType)
        sheet?.completionHandler = { result in
            switch result {
            case .done: completion(.success)
            case .cancelled: completion(.failure(.cancelled))
            }
        }
        sheet?.setInitialText(data.text)
        data.images.forEach {sheet?.add($0) }
        data.urls.forEach { sheet?.add($0) }
        controller.present(sheet!, animated: true, completion: nil)
    }
    
    
    fileprivate class func postToLINE(_ data: SNSShareData, completion: SNSSharePostCompletion) {
        
        var scheme = "line://msg/"
        if let image = data.images.first, let imageData = UIImagePNGRepresentation(image) {
            let pasteboard = UIPasteboard.general
            pasteboard.setData(imageData, forPasteboardType: "public.png")
            scheme += "image/\(pasteboard.name)"
        } else {
            var texts = [String]()
            texts.append(data.text)
            data.urls.forEach{ texts.append($0.absoluteString) }
            let set = CharacterSet.alphanumerics
            guard let text = texts
                .joined(separator: "\n")
                .addingPercentEncoding(withAllowedCharacters: set) else
            {
                completion(.failure(.uriEncodingError))
                return
            }
            scheme += "text/\(text)"
        }
        
        guard let url = URL(string: scheme) else {
            completion(.failure(.unknownError))
            return
        }
        
        UIApplication.shared.openURL(url)
        completion(.success)
    }
    
}
