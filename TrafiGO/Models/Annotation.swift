//
//  Annotation.swift
//  TrafiGO
//
//  Created by Darek on 16/09/2021.
//

import MapKit

class stopAnnotation: NSObject, MKAnnotation {
    let title: String? = ""
    let stopName: String?
    let subtitle: String?
    let stopID: Int
    let coordinate: CLLocationCoordinate2D
    
    init(stopName: String?, subtitle: String?, stopID: Int, coordinate: CLLocationCoordinate2D) {
        self.stopName = stopName
        self.subtitle = subtitle
        self.stopID = stopID
        self.coordinate = coordinate
    }
    
}


class stopAnnotationView: MKAnnotationView {
    
}
