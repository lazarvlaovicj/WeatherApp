//
//  CurrentWeather.swift
//  RainyShinyCloudy
//
//  Created by PRO on 1/27/17.
//  Copyright © 2017 Lazar. All rights reserved.
//

import UIKit
import Alamofire

class CurrentWeather {
    var _cityName : String!
    var _date : String!
    var _weatherType: String!
    var _currentTemp: Double!
    
    var cityName : String {
        if _cityName == nil {
            _cityName = ""
        }
        return _cityName
    }
    
    var weatherType : String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var currentTemp : Double {
        if _currentTemp == nil {
            _currentTemp = 0.0
        }
        return _currentTemp.rounded()
    }
    
    var date : String {
        if _date == nil {
            _date = ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let currentDate = dateFormatter.string(from: Date())
        self._date = "Today, \(currentDate)"
        return _date
    }
    
    func downloadWeatherDetails(completed: @escaping  DownloadComplete){
        //download current weather data
        Alamofire.request(CURRENT_WEATHER_URL).responseJSON{ response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let name = dict["name"] as? String {
                    self._cityName = name
                }
                
                if let weather = dict["weather"] as? [Dictionary<String, AnyObject>] {
                    if let  main = weather[0]["main"] as? String {
                        self._weatherType = main
                    }
                }
                
                if let main = dict["main"] as? Dictionary<String, AnyObject> {
                    if let temp = main["temp"] as? Double {
                        self._currentTemp = temp - 273.15
                    }
                }
            }
            completed()
            
        }
        
        
    }
    
    
}
