//
//  busStopsSearchResultsView.swift
//  TrafiGO
//
//  Created by Darek on 23/09/2021.
//

import UIKit
import Combine
import CoreLocation

class BusStopsSearchResultsView: UIView {
    
    // MARK: - IBOulets
    @IBOutlet weak var busStopsSearchTableView: UITableView!
    
    // MARK: - Variables
    var selectedStops: [StopModel] = []
    var onMapButtonCallback : ((CLLocation) -> Void)?

    // MARK: - View Events
    override func awakeFromNib() {
       super.awakeFromNib()
        busStopsSearchTableView.register(UITableViewCell.self, forCellReuseIdentifier: "searchCell")
        busStopsSearchTableView.delegate = self
        busStopsSearchTableView.dataSource = self
        busStopsSearchTableView.allowsSelection = true
    }
}

// MARK: - Table View Setup
extension BusStopsSearchResultsView: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedStops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchCell = tableView.dequeueReusableCell(withIdentifier: "searchCell")!
        searchCell.textLabel?.text = selectedStops[indexPath.row].stopName
        
        return searchCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let stopLat = selectedStops[indexPath.row].stopLat
        let stopLon = selectedStops[indexPath.row].stopLon
        let location = CLLocation(latitude: stopLat, longitude: stopLon)
        print("DEBUG: clicked: \(selectedStops[indexPath.row].stopName)")
        onMapButtonCallback?(location)
    }
}
