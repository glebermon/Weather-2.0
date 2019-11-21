//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import Network

protocol TestDelegate {
    func testDelegate(city : Int)
}

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate, FavoriteViewControllerDelegate {
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "59e6f6554feff9419329a045ca072f24"
    let unitsMetric = "metric"
    var weatherDataModel = WeatherDataModel()
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")
    
    /***Get your own App ID at https://openweathermap.org/appid ****/
    

    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()
    

    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        netWork()
        monitor.start(queue: queue)

        //TODO:Set up the location manager here.
        /*locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()*/
        
        
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    func getWeatherData(url: String, parameters : [String : String]) {
        
        let headers : HTTPHeaders = ["Content-Type": "application/json"]
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON {
            
            respose in
            if respose.result.isSuccess {
                print("Success!")
                let weatherJSON : JSON = JSON(respose.result.value!)
                self.updateWeatherData(json: weatherJSON)
//                print(weatherJSON)
            } else {
                print("Error \(String(describing: respose.result.error))")
                self.cityLabel.text = "Connection Issues"
            }
            
        }
        
    }

    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    //Write the updateWeatherData method here:
    func updateWeatherData(json : JSON) {
        
        if let tempResult = json["main"]["temp"].double {
            weatherDataModel.temperature = Int(tempResult)
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.condition = json["weather"][0]["id"].intValue
//            print("!!!!!!!!!!!!!!!!!!!!!!!!!!\(json["weather"][0]["id"])")
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            
            updateUIWithWeatherData()
            
        } else {
            self.cityLabel.text = "Weather Unavailable"
        }
    }

    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    func updateUIWithWeatherData() {
        
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = "\(weatherDataModel.temperature)\u{00B0}"
        weatherIcon.image = UIImage(named: weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition))
        
    }
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            
//            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID, "units" : unitsMetric]
            
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
    }
    
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        cityLabel.text = "Location Unavailable"
    }
    
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    
    
    //Write the userEnteredANewCityName Delegate method here:
    
    func userEnteredANewCityName(city : String) {
        
        let params : [String : String] = ["q" : city, "appid" : APP_ID, "units" : unitsMetric]
        getWeatherData(url: WEATHER_URL, parameters: params)
        
    }
    
    func userChoseFavoriteCity(cityId: Int) {
        print(cityId)
        let params : [String : String] = ["id" : String(cityId), "appid" : APP_ID, "units" : unitsMetric]
        getWeatherData(url: WEATHER_URL, parameters: params)
        print(#function)
        print("Город приянт на WeatherViewController")
    }
    

    
    //Write the PrepareForSegue Method here
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let destinationVC = segue.destination as! ChangeCityViewController
            destinationVC.delegate = self
        } else if let nav = segue.destination as? UINavigationController, let svc = nav.topViewController as? FavoriteViewController {
            svc.newCityDelegate = self
        }
    }
    
    
    func netWork() {
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print(#function)
                print("We're connected!")
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
                self.locationManager.requestWhenInUseAuthorization()
                self.locationManager.startUpdatingLocation()
            } else {
                print("No connection.")
            }
            
//            print(path.isExpensive)
        }
    }
}

extension WeatherViewController : TestDelegate {
    func testDelegate(city: Int) {
        print(city)
    }
    
//    func testDelegate(city: String) {
//        let params : [String : String] = ["q" : city, "appid" : APP_ID, "units" : unitsMetric]
//        getWeatherData(url: WEATHER_URL, parameters: params)
//    }
}


