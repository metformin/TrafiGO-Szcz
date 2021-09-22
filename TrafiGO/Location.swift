//
//  Location.swift
//  TrafiGO
//
//  Created by Darek on 22/09/2021.
//

import Foundation
import CoreLocation
import Combine

class Location: NSObject, CLLocationManagerDelegate {
    
    
    var locationManager: CLLocationManager
    var userLocation = PassthroughSubject<CLLocation,Never>()
    
    override init() {
        locationManager = CLLocationManager()
    }
    
    func checkIfLocationIsAuth() -> Bool {
        if CLLocationManager.authorizationStatus() != .authorizedAlways || CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            return false
        } else {
            return true
        }
    }
    
    func requestLocation(){
        if checkIfLocationIsAuth() == false {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            
        }
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.last
        userLocation.send(currentLocation!)
        locationManager.stopUpdatingLocation()
    }
}



