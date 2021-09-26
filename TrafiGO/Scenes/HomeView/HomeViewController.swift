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
    // MARK: - IBOulets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var busStopsSearchBar: UISearchBar!
    @IBOutlet weak var busStopsSearchBarView: UIView!
    @IBOutlet weak var centerToUserLocationButton: UIButton!
    
    // MARK: - Variables
    let homeViewModel = HomeViewModel()
    var subscriptions = Set<AnyCancellable>()
    var tableViewAnnotation = UITableView()
    var tableViewSearch = UITableView()
    var customSearchView = BusStopsSearchResultsView()
    var customAnnotationView = AnnotationView()

    // MARK: - IBActions
    @IBAction func centerToUserLocationButton(_ sender: Any) {
        homeViewModel.getUserLocation()
    }
  
    // MARK: - View Events
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        mapView.centerToLocation(homeViewModel.initialLocation)
        fetchStopsAndConvertFromJSON()
        mapView.delegate = self
        busStopsSearchBar.delegate = self
        
        homeViewModel.userLocation
            .sink { [weak self] location in
                self?.centerMap(at: location)
            }.store(in: &subscriptions)
        
        homeViewModel.timeTable.sink {[weak self] results in
            if let tableView = self?.customAnnotationView.annTab {
                self?.tableViewAnnotation = tableView
                self?.tableViewAnnotation.delegate = self
                self?.tableViewAnnotation.dataSource = self
                self?.customAnnotationView.loadingBusInfoIndicator.stopAnimating()
                print("DEBUG: Data: \(results)(9)")
                self?.customAnnotationView.annTab.reloadData()
            }
        }.store(in: &subscriptions)
        
        homeViewModel.selectedStopsForSearch.sink {[weak self] results in
            self?.customSearchView.selectedStops = results
            if let tableView = self?.customSearchView.busStopsSearchTableView {
                self?.tableViewSearch = tableView
                self?.customSearchView.busStopsSearchTableView.reloadData()
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
        customAnnotationView = Bundle.main.loadNibNamed("AnnotationView", owner: self, options: nil)?.first as! AnnotationView
        customAnnotationView.titleLAbel.text = annotation.stopName
        customAnnotationView.loadingBusInfoIndicator.startAnimating()
        view.detailCalloutAccessoryView = customAnnotationView
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
    
    func showBusStopsSearchResultsView(){
        customSearchView = Bundle.main.loadNibNamed("BusStopsSearchResultsView", owner: self, options: nil)?.first as! BusStopsSearchResultsView
        customSearchView.tag = 10
        customSearchView.onMapButtonCallback = { location in self.centerMap(at: location) }

        UIView.transition(with: self.view, duration: 0.3, options: [.curveLinear], animations: {
            self.view.addSubview(self.customSearchView)
        }, completion: nil)
        customSearchView.translatesAutoresizingMaskIntoConstraints = false
            let horizontalConstraint = customSearchView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            let verticalConstraint = customSearchView.topAnchor.constraint(equalTo: busStopsSearchBarView.bottomAnchor)
            let widthConstraint = customSearchView.widthAnchor.constraint(equalTo: busStopsSearchBarView.widthAnchor)
            let heightConstraint = customSearchView.heightAnchor.constraint(equalToConstant: 200)
            view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
    }
    
    func centerMap(at point: CLLocation){
        print("Location: \(point)")
        mapView.centerToLocation(point, regionRadius: 300)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
   
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
        return cell
    }
}

extension HomeViewController: UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
      showBusStopsSearchResultsView()
        homeViewModel.setupSearchBusStop()

    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let removable = view.viewWithTag(10){
           removable.removeFromSuperview()
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("DEBUG: Search text: \(searchText)" )
        homeViewModel.busStopsSearchText.send(searchText)
    }
}

