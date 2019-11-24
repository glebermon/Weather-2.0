//
//  NetworkService.swift
//  Clima
//
//  Created by Глеб on 23.11.2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NetworkService {
    public func loadWeatherAlamofire(parameters : [String : String] ,completionHandler: (([WeatherDataModelNew]?, Error?) -> Void)? = nil) {
        
        let headers : HTTPHeaders = ["Content-Type": "application/json"]
        
        Alamofire.request(API.WEATHER_URL_GROUP, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .failure(let error):
                completionHandler?(nil, error)
                print(error.localizedDescription)
            case .success(let value):
                let json = JSON(value)
//                print(json)
                let weather = json["list"].arrayValue.map { WeatherDataModelNew(json: $0) }
//                return weather
                completionHandler?(weather, nil)
            }
        }
    }
    
//    static func urlForFriendVK(_ avatar: String) -> URL? {
//        return URL(string: avatar)
//    }
    
    
    func getWeatherData(url: String, parameters : [String : String]) {
        
        let headers : HTTPHeaders = ["Content-Type": "application/json"]
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (respose) in
            
            if respose.result.isSuccess {
                print("Success!")
//                let weatherJSON : JSON = JSON(respose.result.value!)
//                self.updateWeatherData(json: weatherJSON)
            } else {
                print("Error \(String(describing: respose.result.error))")
//                self.cityLabel.text = "Connection Issues"
            }
            
        }
    }
}
