//
//  LocationManager.swift
//  benhvien-phongkham
//
//  Created by HaoLe on 12/31/15.
//  Copyright © 2015 HaoLe. All rights reserved.
//

import Foundation
import MapKit

typealias LocationManagerCompletionHandler = (location: CLLocationCoordinate2D?, error: NSError?) -> ()

class LocationManager: NSObject {

    private var locateManage = CLLocationManager()
    private var handler: LocationManagerCompletionHandler? = nil
    var currentCoordinate: CLLocationCoordinate2D?
    
    class var sharedInstance: LocationManager {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: LocationManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = LocationManager()
            Static.instance?.initLocationManager()
        }
        return Static.instance!
    }
    
    private func initLocationManager() {
        loggingPrint("Created")
        
        //-------------CLLocationManager-------------//
        self.locateManage.delegate = self
        if self.locateManage.respondsToSelector(#selector(CLLocationManager.requestAlwaysAuthorization)) {
            self.locateManage.requestAlwaysAuthorization()
        }
        self.locateManage.desiredAccuracy = kCLLocationAccuracyBest
    }
    
}

//MARK: - Public methods
extension LocationManager {
    
    func startUpdatingLocation() {
        self.locateManage.startUpdatingLocation()
    }
    
    func currentLocation(completionHandler: LocationManagerCompletionHandler) {
        self.handler = completionHandler
        self.startUpdatingLocation()
    }
}

//MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0]
        let long = userLocation.coordinate.longitude;
        let lat = userLocation.coordinate.latitude;
        self.currentCoordinate = CLLocationCoordinate2D(latitude: Double(lat), longitude: Double(long))
        if let _ = self.handler {
            self.handler!(location: self.currentCoordinate, error: nil)
            self.handler = nil
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        if let _ = self.handler {
            self.handler!(location: nil, error: error)
            self.handler = nil
        }
    }
    
}

