//
//  HomeViewModel.swift
//  TrafiGO
//
//  Created by Darek on 15/09/2021.
//

import Foundation
import Combine
import CoreLocation
import UIKit

class HomeViewModel: ObservableObject{

    // MARK: - Constants
    let initialLocation = CLLocation(latitude: 53.436554, longitude: 14.566362)
    let busStopInfoDownloader = BusStopInfoDownloader()
    let location = LocationSetup()
    var timeTable = CurrentValueSubject<[[String]], Never>([[]])
    var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Variables
    var allStopsData = CurrentValueSubject<[StopModel],Error>([])
    var userLocation = PassthroughSubject<CLLocation,Never>()
    var busStopsSearchText = CurrentValueSubject<String, Never>("")
    var selectedStopsForSearch = CurrentValueSubject<[StopModel],Never>([])

    // MARK: - init(s)
    init() {
        location.userLocation
            .sink { [weak self] location in
                self?.userLocation.send(location)
        }
            .store(in: &subscriptions)
        
        busStopInfoDownloader.timeTable
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("DEBUG: Completion finished")
                    break
                case .failure(let error):
                    print("DEBUG: Completion failure: \(error)")
                    break
                }
            }, receiveValue: {[weak self] results in
                self?.timeTable.send(results)
            })
             .store(in: &subscriptions)
    }
    
    func setupSearchBusStop(){
        busStopsSearchText
            .removeDuplicates()
            .map{[unowned self] text -> [StopModel] in
                self.searchBusStop(search: text)
            }
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self]selectedStops in
                self?.selectedStopsForSearch.send(selectedStops)
            }.store(in: &subscriptions)
    }
    
    func searchBusStop(search text: String) -> [StopModel]{
        let allStops = allStopsData.value
        var selectedStops: [StopModel] = []
        
        for stop in allStops {
            if stop.stopName.contains(text){
                selectedStops.append(stop)
            }
        }
        
        return selectedStops
    }
    
    func decodeStopsInfoFromJSON(){
        if let stopsJSON = Bundle.main.url(forResource: "stops", withExtension: "json"){
            do {
                let data = try Data(contentsOf: stopsJSON)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([StopModel].self, from: data)
                allStopsData.send(jsonData)
            }catch{
                print("Error with stops JSON decode: \(error)")
            }
        }
    }
    
    func getUserLocation(){
        location.requestLocation()
    }
    
    func downloadBusStopInfo(stopID: Int){
        busStopInfoDownloader.downloadInfoAboutSpecificBusStop(stopID: stopID)
    }
}
