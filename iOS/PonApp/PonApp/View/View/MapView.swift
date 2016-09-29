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
    func mapView(mapView: MapView!, didDragMarker marker: MapMarker!)
    func mapView(mapView: MapView!, didEndDraggingMarker marker: MapMarker!)
    func mapView(mapView: MapView!, didTapMarker marker: MapMarker!)
    func mapView(mapView: MapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D)
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
    
    private func initialize() {
        self.delegate = self
    }
    
    
    private func createFakeMarker(coordinate: CLLocationCoordinate2D) {
        self.clear()
        let marker = MapMarker(position: coordinate)
        marker.icon = UIImage(named: "map_icon_marker")
        marker.appearAnimation = kGMSMarkerAnimationNone
        marker.map = self
    }
    
    func moveToCurentLocation() {
        LocationManager.sharedInstance.currentLocation { (location: CLLocationCoordinate2D?, error: NSError?) -> () in
            if let _ = error {
                
            }else {
                let cameraPos = GMSCameraPosition.cameraWithLatitude( Double((location?.latitude)!), longitude: Double((location?.longitude)!), zoom: 15.0)
                self.camera = cameraPos
            }
        }
    }
    
    func moveCameraToLocation(location: CLLocationCoordinate2D) {
        let cameraPos = GMSCameraPosition.cameraWithLatitude( location.latitude, longitude: location.longitude, zoom: 15.0)
        self.camera = cameraPos
    }
    
    private func createShopMarkers() {
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


extension MapView: GMSMapViewDelegate {
    
    func mapView(mapView: GMSMapView, didDragMarker marker: GMSMarker) {
        self.handler?.mapView(self, didDragMarker: marker as! MapMarker)
    }
    
    func mapView(mapView: GMSMapView, didEndDraggingMarker marker: GMSMarker) {
        self.handler?.mapView(self, didEndDraggingMarker: marker as! MapMarker)
    }
    
    func mapView(mapView: GMSMapView, willMove gesture: Bool) {
        
    }
    
    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
        self.handler?.mapView(self, didTapMarker: marker as! MapMarker)
        return true
    }
    
    func mapView(mapView: GMSMapView, didTapInfoWindowOfMarker marker: GMSMarker) {
        
    }
    
    func mapView(mapView: GMSMapView, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        self.handler?.mapView(self, didTapAtCoordinate: coordinate)
    }
    
    func mapView(mapView: GMSMapView, didTapOverlay overlay: GMSOverlay) {
        
    }
    
    func mapView(mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return UIView()
    }
    
}