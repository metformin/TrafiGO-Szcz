//
//  HomeViewModel.swift
//  TrafiGO
//
//  Created by Darek on 15/09/2021.
//

import Foundation
import Combine

class HomeViewModel{
    var allStopsData = PassthroughSubject<[StopModel],Error>()
    let busStopInfoDownloader = BusStopInfoDownloader()
    var timeTable = CurrentValueSubject<[[String]], Never>([[]])
    var subscriptions = Set<AnyCancellable>()


   
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
    
    func downloadBusStopInfo(stopID: Int){
        busStopInfoDownloader.downloadInfoAboutSpecificBusStop(stopID: stopID)
        busStopInfoDownloader.timeTable.sink { results in
            self.timeTable.send(results)
        }.store(in: &subscriptions)
    }
    
}
