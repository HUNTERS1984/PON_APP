//
//  MapView.swift
//  PonApp
//
//  Created by HaoLe on 9/5/16.
//  Copyright © 2016 HaoLe. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps

protocol MapViewDelegate: class {
    func mapView(_ mapView: MapView!, didDragMarker marker: MapMarker!)
    func mapView(_ mapView: MapView!, didEndDraggingMarker marker: MapMarker!)
    func mapView(_ mapView: MapView!, didTapMarker marker: MapMarker!)
    func mapView(_ mapView: MapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D)
}

class MapView: GMSMapView {
    
    weak var handler: MapViewDelegate? = nil
    var cameraPosition: GMSCameraPosition!
    
    var shops = [Shop]() {
        didSet {
            self.createShopMarkers()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    fileprivate func initialize() {
        self.delegate = self
    }
    
    func moveToCurentLocation() {
        LocationManager.sharedInstance.currentLocation { (location: CLLocationCoordinate2D?, error: NSError?) -> () in
            if let _ = error {
                
            }else {
                let cameraPos = GMSCameraPosition.camera( withLatitude: Double((location?.latitude)!), longitude: Double((location?.longitude)!), zoom: 15.0)
                self.camera = cameraPos
            }
        }
    }
    
    func moveCameraToLocation(_ location: CLLocationCoordinate2D) {
        let cameraPos = GMSCameraPosition.camera( withLatitude: location.latitude, longitude: location.longitude, zoom: 15.0)
        self.camera = cameraPos
    }
    
    func createShopMarker(_ location: CLLocationCoordinate2D) {
        self.clear()
        let marker = MapMarker(position: location)
        marker.icon = UIImage(named: "coupon_map_detail_icon")
        marker.appearAnimation = kGMSMarkerAnimationNone
        marker.map = self
        let cameraPos = GMSCameraPosition.camera( withLatitude: location.latitude, longitude: location.longitude, zoom: 12.0)
        self.camera = cameraPos
    }
    
}

//MARK: - Private
extension MapView {
    
    fileprivate func createShopMarkers() {
        self.clear()
        if self.shops.count == 0 {
            return
        }else {
            for shop in self.shops {
                let marker = MapMarker(position: shop.coordinate)
                marker.icon = UIImage(named: "map_icon_marker")
                marker.mapMarkerId = shop.shopID
                marker.shop = shop
                marker.appearAnimation = kGMSMarkerAnimationNone
                marker.map = self
            }
        }
    }
    
}

//MARK: - GMSMapViewDelegate
extension MapView: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        self.handler?.mapView(self, didDragMarker: marker as! MapMarker)
    }
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        self.handler?.mapView(self, didEndDraggingMarker: marker as! MapMarker)
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        self.handler?.mapView(self, didTapMarker: marker as! MapMarker)
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.handler?.mapView(self, didTapAtCoordinate: coordinate)
    }
    
    func mapView(_ mapView: GMSMapView, didTap overlay: GMSOverlay) {
        
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return UIView()
    }
    
}
