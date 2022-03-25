//
//  Stop.swift
//  CalAlert
//
//  Created by Ryan Dirajlal on 5/16/21.
//



import Foundation
import CoreLocation

struct Stop: Codable, Identifiable {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
  
    
    static let allStops: [Stop] = Bundle.main.decode("stops.json")

    
    
    static let example =  allStops[0]
       

}
