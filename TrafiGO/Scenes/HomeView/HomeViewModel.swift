//
//  HomeViewModel.swift
//  TrafiGO
//
//  Created by Darek on 15/09/2021.
//

import Foundation
import Combine
import CoreLocation

class HomeViewModel{
    var allStopsData = PassthroughSubject<[StopModel],Error>()
    var userLocation = PassthroughSubject<CLLocation,Never>()
    let busStopInfoDownloader = BusStopInfoDownloader()
    let location = Location()
    var timeTable = CurrentValueSubject<[[String]], Never>([[]])
    var subscriptions = Set<AnyCancellable>()
    
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
