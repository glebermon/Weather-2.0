//
//  File.swift
//  Clima
//
//  Created by Глеб on 17.11.2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit


struct CitiesList : Decodable {
    var citiesList : [City]
}

struct City : Decodable {
    var id : Int
    var name : String
    var country : String
}
