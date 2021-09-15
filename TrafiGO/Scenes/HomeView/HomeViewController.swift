//
//  ViewController.swift
//  TrafiGO
//
//  Created by Darek on 15/09/2021.
//

import UIKit
import MapKit
import Combine

class HomeViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    let homeViewModel = HomeViewModel()
    let initialLocation = CLLocation(latitude: 53.436554, longitude: 14.566362)
    var subscriptions = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapView.centerToLocation(initialLocation)
        fetchStopsAndConvertFromJSON()
        mapView.delegate = self
        
    }
    
    func fetchStopsAndConvertFromJSON(){
        homeViewModel.allStopsData
            .sink { complition in
                print("allStopsData louded")
            } receiveValue: { stops in
                self.addStopsToMap(stops: stops)
            }.store(in: &subscriptions)
        
        homeViewModel.decodeStopsInfoFromJSON()
    }
    
    func addStopsToMap(stops: [StopModel]){
        for stop in stops{
           let pin = MKPointAnnotation()
            pin.title = stop.stopName
            pin.coordinate = CLLocationCoordinate2D(latitude: stop.stopLat, longitude: stop.stopLon)
            
            mapView.addAnnotation(pin)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
       {
        
           if !(annotation is MKPointAnnotation) {
               return nil
           }
           
           let annotationIdentifier = "AnnotationIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
           
           if annotationView == nil {
               annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
               annotationView!.canShowCallout = true
           }
           else {
               annotationView!.annotation = annotation
           }
           
           let pinImage = UIImage(named: "stopPinIcon")
           annotationView!.image = pinImage
        annotationView?.frame.size = CGSize(width: 30, height: 40)
        

        annotationView?.clusteringIdentifier = "xD"

          return annotationView
       }
    

}

