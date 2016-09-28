//
//  StringExtension.swift
//  MassageIOS
//
//  Created by HaoLe on 7/13/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit

extension String {
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.max)
        
        let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
    
    func heightForWithFont(font: UIFont, width: CGFloat, insets: UIEdgeInsets) -> CGFloat {
        
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width + insets.left + insets.right, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = self
        
        label.sizeToFit()
        return label.frame.height + insets.top + insets.bottom
    }
    
    func md5() -> String! {
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CUnsignedInt(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.destroy()
        
        return String(format: hash as String)
    }
    
    static func validate(email: String) -> Bool {
        let REGEX: String
        REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluateWithObject(email)
    }
    
    func isEmpty() -> Bool {
        let trimmed = self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        return trimmed.isEmpty
    }
    
}

extension String {
    
    static func sha256(str: String) -> String? {
        guard
            let data = str.dataUsingEncoding(NSUTF8StringEncoding),
            let shaData = sha256(data)
            else { return nil }
        let rc = shaData.base64EncodedStringWithOptions([])
        return rc
    }
    
    static func sha256(data: NSData) -> NSData? {
        guard let res = NSMutableData(length: Int(CC_SHA256_DIGEST_LENGTH)) else { return nil }
        CC_SHA256(data.bytes, CC_LONG(data.length), UnsafeMutablePointer(res.mutableBytes))
        return res
    }
    
}

extension String {
    
    static func convertDateFormater(dateString: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss+zzzz"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        
        guard let date = dateFormatter.dateFromString(dateString) else {
            assert(false, "no date from string")
            return ""
        }
        
        dateFormatter.dateFormat = "yyyy.MM.dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        let timeStamp = dateFormatter.stringFromDate(date)
        
        return timeStamp
    }
    
}
