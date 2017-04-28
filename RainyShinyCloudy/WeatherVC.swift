//
//  WeatherVC.swift
//  RainyShinyCloudy
//
//  Created by PRO on 1/24/17.
//  Copyright © 2017 Lazar. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class WeatherVC: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var currentTemperatureLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var currentImgLbl: UIImageView!
    @IBOutlet weak var currentWeatherTypeLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var currentWeather = CurrentWeather()
    //var forecast: Forecast!
    var forecasts = [Forecast]()
    
    var locationManager = CLLocationManager()
    var currentLocation : CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation() // Ovo pozoves samo prvi put, da bi dobio lokaciju i povukao sve podatke sa servera ili kakva je vec logika, nisam zapratio... pogledaj dole dalje komentare
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestWhenInUseAuthorization()
    }
    
    //Malo sam promenio nacin na koji trazis permisije od korisnika
    public func requestWhenInUseAuthorization(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            break
        case .notDetermined:
            self.locationManager.requestAlwaysAuthorization()
            break
            
        case .restricted, .denied:
            if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
            break
        default: break
            
        }
    }
    
    //    func locationAuth() {
    //        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
    //                currentLocation = locationManager.location
    //                Location.sharedInstance.latitude = currentLocation.coordinate.latitude
    //                Location.sharedInstance.longitude = currentLocation.coordinate.longitude
    //                print(Location.sharedInstance.latitude, Location.sharedInstance.longitude)
    //
    //                currentWeather.downloadWeatherDetails {
    //                    self.downloadForecastData {
    //                        self.updateUI()
    //                    }
    //
    //                }
    //        }
    //        else {
    //            locationManager.requestWhenInUseAuthorization()
    //            locationAuth()
    //        }
    //    }
    
    
    
    func downloadForecastData (completed: @escaping DownloadComplete) {
        //download forecast weather data for TableVIew
        Alamofire.request(FORECAST_URL).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
                    
                    for obj in list {
                        let forecast = Forecast(weatherDict: obj)
                        self.forecasts.append(forecast)
                    }
                    self.forecasts.remove(at: 0)
                    self.tableView.reloadData()
                }
                
            }; completed()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let  cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as? WeatherCell {
            let forecast = forecasts[indexPath.row]
            cell.configureCell(forecast: forecast)
            return cell
        }
        else {
            return WeatherCell()
        }
        
    }
    
    func updateUI() {
        dateLbl.text = currentWeather.date
        currentTemperatureLbl.text = "\(currentWeather.currentTemp)°C"
        locationLbl.text = currentWeather.cityName
        currentWeatherTypeLbl.text = currentWeather.weatherType
        currentImgLbl.image = UIImage(named: currentWeather.weatherType)
    }
    
    //Ova metoda se pozove nakon sto se uradi updateLokaciju. parametar "locations" je niz lokacija, uzmes poslednju jer je poslednja najsvezija, i onda radis sa njom sta treba da radis.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        Location.sharedInstance.latitude = currentLocation.coordinate.latitude
        Location.sharedInstance.longitude = currentLocation.coordinate.longitude
        print(Location.sharedInstance.latitude, Location.sharedInstance.longitude)
        
        currentWeather.downloadWeatherDetails {
            self.downloadForecastData {
                self.updateUI()
            }
        }
        manager.stopUpdatingLocation() //Nakon prvog update lokacije zaustavljamo manager i lokacija se vise ne updejtuje
        manager.startMonitoringSignificantLocationChanges() //Ova metoda prati samo velike promene u lokaciji, dakle, ako dodjes sa petrovaradina u centar on ce da primeti. Ovo nisam nikada koristio, ali sam procitao opis metode u dokumentaciji
        
    }
}
