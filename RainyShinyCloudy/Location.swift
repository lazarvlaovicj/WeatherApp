//
//  Location.swift
//  RainyShinyCloudy
//
//  Created by PRO on 2/5/17.
//  Copyright © 2017 Lazar. All rights reserved.
//

import CoreLocation

class Location {
    
    static var sharedInstance = Location()
    private init() {}
    
    var latitude : Double!
    var longitude : Double!
    
}
