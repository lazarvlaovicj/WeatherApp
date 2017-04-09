//
//  Constants.swift
//  RainyShinyCloudy
//
//  Created by PRO on 1/27/17.
//  Copyright © 2017 Lazar. All rights reserved.
//

import Foundation

typealias DownloadComplete = () -> ()

let CURRENT_WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather?lat=\(Location.sharedInstance.latitude!)&lon=\(Location.sharedInstance.longitude!)&appid=187b3d8bebe3cff27c1e97b527584064"

let FORECAST_URL = "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(Location.sharedInstance.latitude!)&lon=\(Location.sharedInstance.longitude!)&cnt=10&mode=json&appid=187b3d8bebe3cff27c1e97b527584064"
