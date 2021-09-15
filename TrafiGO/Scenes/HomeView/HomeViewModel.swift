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
    
}
