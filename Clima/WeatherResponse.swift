//
//  WeatherResponse.swift
//  Weather2
//
//  Created by Mac on 12.11.2019.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

struct WeatherResponse: Codable {
     
    var weathersData: [WeatherData]?
    
    enum CodingKeys: String, CodingKey {
        case weathersData = "list"
    }
}

struct OneWeatherResponse : Codable {
    var weather : Weather?
}
