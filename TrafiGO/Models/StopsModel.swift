//
//  StopsModel.swift
//  TrafiGO
//
//  Created by Darek on 15/09/2021.
//

import Foundation


struct StopModel: Decodable {
    let stopID, stopCode: Int
    let stopName: String
    let stopDesc: StopDesc
    let stopLat, stopLon: Double
    let stopURL: String
    let locationType, parentStation: String

    enum CodingKeys: String, CodingKey {
        case stopID = "stop_id"
        case stopCode = "stop_code"
        case stopName = "stop_name"
        case stopDesc = "stop_desc"
        case stopLat = "stop_lat"
        case stopLon = "stop_lon"
        case stopURL = "stop_url"
        case locationType = "location_type"
        case parentStation = "parent_station"
    }
}

enum StopDesc: String, Codable {
    case empty = ""
    case naŻądanie = "na żądanie"
}
