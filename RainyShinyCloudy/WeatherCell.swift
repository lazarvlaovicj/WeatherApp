//
//  WeatherCell.swift
//  RainyShinyCloudy
//
//  Created by PRO on 2/1/17.
//  Copyright © 2017 Lazar. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var weatherType: UILabel!
    @IBOutlet weak var highTemp: UILabel!
    @IBOutlet weak var lowTemp: UILabel!
    
    func configureCell(forecast: Forecast) {
        lowTemp.text = "\(forecast.lowTemp)°C"
        highTemp.text = "\(forecast.highTemp)°C"
        weatherType.text = forecast.weatherType
        dayLbl.text = forecast.date
        weatherIcon.image = UIImage(named: forecast.weatherType)
    }
}
