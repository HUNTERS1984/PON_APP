//
//  Location.swift
//  CouponFinder
//
//  Created by HaoLe on 12/11/15.
//  Copyright © 2015 HaoLe. All rights reserved.
//

import Foundation
import CoreLocation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class Location {
    
    class func geocodeAddressString(_ address:String, completion:@escaping (_ placemark:CLPlacemark?, _ error:NSError?)->Void){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) -> Void in
            if error == nil{
                if placemarks?.count > 0{
                    completion((placemarks?[0]), error as NSError?)
                }
            }
            else{
                completion(nil, error as NSError?)
            }
        })
    }
    
    class func reverseGeocodeLocation(_ location:CLLocation,completion:@escaping (_ placemark:CLPlacemark?, _ error:NSError?)->Void){
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            if let err = error{
                print("Error Reverse Geocoding Location: \(err.localizedDescription)")
                completion(nil, error as NSError?)
                return
            }
            completion(placemarks?[0], nil)
            
        })
    }
    
    class func addressFromPlacemark(_ placemark:CLPlacemark)->String{
        var address = ""
        let name = placemark.addressDictionary?["Name"] as? String
        let city = placemark.addressDictionary?["City"] as? String
        let state = placemark.addressDictionary?["State"] as? String
        let country = placemark.country
        
        if name != nil{
            address = constructAddressString(address, newString: name!)
        }
        if city != nil{
            address = constructAddressString(address, newString: city!)
        }
        if state != nil{
            address = constructAddressString(address, newString: state!)
        }
        if country != nil{
            address = constructAddressString(address, newString: country!)
        }
        return address
    }
    
    fileprivate class func constructAddressString(_ string:String, newString:String)->String{
        var address = string
        if !address.isEmpty{
            address = address + ", \(newString)"
        }
        else{
            address = address + newString
        }
        return address
    }
}
