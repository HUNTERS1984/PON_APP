//
//  Location.swift
//  CouponFinder
//
//  Created by HaoLe on 12/11/15.
//  Copyright © 2015 HaoLe. All rights reserved.
//

import Foundation
import CoreLocation

class Location{
    
    class func geocodeAddressString(address:String, completion:(placemark:CLPlacemark?, error:NSError?)->Void){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) -> Void in
            if error == nil{
                if placemarks?.count > 0{
                    completion(placemark: (placemarks?[0]), error: error)
                }
            }
            else{
                completion(placemark: nil, error: error)
            }
        })
    }
    
    class func reverseGeocodeLocation(location:CLLocation,completion:(placemark:CLPlacemark?, error:NSError?)->Void){
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            if let err = error{
                print("Error Reverse Geocoding Location: \(err.localizedDescription)")
                completion(placemark: nil, error: error)
                return
            }
            completion(placemark: placemarks?[0], error: nil)
            
        })
    }
    
    class func addressFromPlacemark(placemark:CLPlacemark)->String{
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
    
    private class func constructAddressString(string:String, newString:String)->String{
        var address = string
        if !address.isEmpty{
            address = address.stringByAppendingString(", \(newString)")
        }
        else{
            address = address.stringByAppendingString(newString)
        }
        return address
    }
}
