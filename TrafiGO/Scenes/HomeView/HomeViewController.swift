//
//  ViewController.swift
//  TrafiGO
//
//  Created by Darek on 15/09/2021.
//

import UIKit
import MapKit
import Combine

class HomeViewController: UIViewController, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource {

    
    
    @IBOutlet weak var mapView: MKMapView!
    let homeViewModel = HomeViewModel()
    let initialLocation = CLLocation(latitude: 53.436554, longitude: 14.566362)
    var subscriptions = Set<AnyCancellable>()
    var tableViewNib = UITableView()

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
            let coordinate = CLLocationCoordinate2D(latitude: stop.stopLat, longitude: stop.stopLon)
            let pin = stopAnnotation(stopName: stop.stopName, subtitle: stop.stopDesc.rawValue, stopID: stop.stopID, coordinate: coordinate)
            
            mapView.addAnnotation(pin)
        }
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? stopAnnotation else {
            return
        }
        
        print("Annotation: \(annotation.stopID)")
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        
        guard let annotation = annotation as? stopAnnotation else {
          return nil
        }
           
        let annotationIdentifier = "busStop"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
           
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView!.canShowCallout = true
            
            let customView = Bundle.main.loadNibNamed("annotationView", owner: self, options: nil)?.first as! annotationView
            customView.titleLAbel.text = annotation.stopName
            
            if let tableView = customView.annTab {
                tableViewNib = tableView
                tableViewNib.delegate = self
                tableViewNib.dataSource = self
            }

            
            annotationView?.detailCalloutAccessoryView = customView
            
        } else {
            annotationView!.annotation = annotation
        }
           
        let pinImage = UIImage(named: "stopPinIcon")
    
        annotationView!.image = pinImage
        annotationView?.frame.size = CGSize(width: 30, height: 40)



        annotationView?.clusteringIdentifier = "bus"

        return annotationView
       }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("AnnotationTableViewCell", owner: self, options: nil)?.first as! AnnotationTableViewCell
        
        return cell
    }
    
    
    
}

