//
//  LocationManager.swift
//  benhvien-phongkham
//
//  Created by HaoLe on 12/31/15.
//  Copyright © 2015 HaoLe. All rights reserved.
//

import Foundation
import MapKit

typealias LocationManagerCompletionHandler = (_ location: CLLocationCoordinate2D?, _ error: NSError?) -> ()

class LocationManager: NSObject {

    var locateManage = CLLocationManager()
     var handler: LocationManagerCompletionHandler? = nil
    var currentCoordinate: CLLocationCoordinate2D?
    
    class var sharedInstance: LocationManager {
        struct Static {
            static let instance = LocationManager()
        }
        return Static.instance
    }
    
    func initLocationManager() {
        self.locateManage.delegate = self
        if self.locateManage.responds(to: #selector(CLLocationManager.requestAlwaysAuthorization)) {
            self.locateManage.requestAlwaysAuthorization()
        }
        self.locateManage.desiredAccuracy = kCLLocationAccuracyBest
    }
    
}

//MARK: - Public methods
extension LocationManager {
    
    func startUpdatingLocation() {
        self.locateManage.stopUpdatingLocation()
        self.locateManage.startUpdatingLocation()
    }
    
    func currentLocation(_ completionHandler: @escaping (LocationManagerCompletionHandler)) {
        self.handler = completionHandler
        self.startUpdatingLocation()
    }
}

//MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0]
        let long = userLocation.coordinate.longitude;
        let lat = userLocation.coordinate.latitude;
        self.currentCoordinate = CLLocationCoordinate2D(latitude: Double(lat), longitude: Double(long))
        if let _ = self.handler {
            self.handler!(self.currentCoordinate, nil)
            self.handler = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let _ = self.handler {
            self.handler!(nil, error as NSError?)
            self.handler = nil
        }
    }
    
}

