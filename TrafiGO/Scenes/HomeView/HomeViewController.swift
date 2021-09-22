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
    var tableViewNib = UITableView()
    var customView = annotationView()
    @IBOutlet weak var centerToUserLocationButton: UIButton!
    @IBAction func centerToUserLocationButton(_ sender: Any) {
        homeViewModel.getUserLocation()
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapView.centerToLocation(initialLocation)
        fetchStopsAndConvertFromJSON()
        mapView.delegate = self
        homeViewModel.userLocation
            .sink { [weak self] location in
                self?.mapView.centerToLocation(location, regionRadius: 500)
            }.store(in: &subscriptions)
        
        homeViewModel.timeTable.sink {[weak self] results in
            if let tableView = self?.customView.annTab {
                self?.tableViewNib = tableView
                self?.tableViewNib.delegate = self
                self?.tableViewNib.dataSource = self
                self?.customView.loadingBusInfoIndicator.stopAnimating()
                print("DEBUG: Data: \(results)(9)")
                self?.customView.annTab.reloadData()
            }
        }.store(in: &subscriptions)
        
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
        
        customView = Bundle.main.loadNibNamed("annotationView", owner: self, options: nil)?.first as! annotationView
        customView.titleLAbel.text = annotation.stopName

        customView.loadingBusInfoIndicator.startAnimating()
        view.detailCalloutAccessoryView = customView
        

        homeViewModel.downloadBusStopInfo(stopID: annotation.stopID)
        
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
        } else {
            annotationView!.annotation = annotation
        }
           
        let pinImage = UIImage(named: "stopPinIcon")
    
        annotationView!.image = pinImage
        annotationView?.frame.size = CGSize(width: 30, height: 40)



        annotationView?.clusteringIdentifier = "bus"

        return annotationView
       }
}

extension HomeViewController: UITableViewDelegate,UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel.timeTable.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("AnnotationTableViewCell", owner: self, options: nil)?.first as! AnnotationTableViewCell
        

        if homeViewModel.timeTable.value[indexPath.row].count == 1{
            cell.busDestinationLabel.text = "Brak zaplanowanych przyjazdów"
        } else {
            cell.busNumberLabel.text = homeViewModel.timeTable.value[indexPath.row][0]
            cell.busDestinationLabel.text = homeViewModel.timeTable.value[indexPath.row][1]
            cell.busTimeLabel.text = homeViewModel.timeTable.value[indexPath.row][2]
        }
        
        
        
        if homeViewModel.timeTable.value.count > 1 {

        } else {
        }
        return cell
    }

}

