//
//  Stops.swift
//  CalAlert
//
//  Created by Ryan Dirajlal on 5/16/21.
//

import Foundation

class Stops: ObservableObject {
    let places: [Stop]


    var primary: Stop {
        places[0]
    }
 

    init() {
        let url = Bundle.main.url(forResource: "stops", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        places = try! JSONDecoder().decode([Stop].self, from: data)
       
    }
}
