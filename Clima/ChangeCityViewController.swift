//
//  ChangeCityViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import iOSDropDown


//Write the protocol declaration here:
protocol ChangeCityDelegate {
    func userEnteredANewCityName(city : String)
}


class ChangeCityViewController: UIViewController {
    
    var cities = [City]()
    var testArr = [String]()
    
    var segueId = ""
    
    //Declare the delegate variable here:
    var delegate : ChangeCityDelegate?
    
    //This is the pre-linked IBOutlets to the text field:
    @IBOutlet weak var changeCityTextField: DropDown!

    
    //This is the IBAction that gets called when the user taps on the "Get Weather" button:
    @IBAction func getWeatherPressed(_ sender: AnyObject) {
        
        var cityName = ""
        if segueId == "123" {
        //1 Get the city name the user entered in the text field
            var n = 1
            for (i, v) in changeCityTextField.text!.enumerated() {
                
                if v == "," {
                    if n == 2 {
                        cityName = (changeCityTextField.text!.dropFirst(i + 1)).trimmingCharacters(in: .whitespacesAndNewlines)
//                        print(cityName)
                    }
                n += 1
                }
            }
        } else {
            cityName = changeCityTextField.text!
        }
        
        //2 If we have a delegate set, call the method userEnteredANewCityName
        delegate?.userEnteredANewCityName(city: cityName)
        
        //3 dismiss the Change City View Controller to go back to the WeatherViewController
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        listOfCitiesJSON()
        changeCityTextField.arrowColor = .clear
        changeCityTextField.selectedRowColor = .lightGray
        changeCityTextField.optionArray = testArr
    }
    
    

    //This is the IBAction that gets called when the user taps the back button. It dismisses the ChangeCityViewController.
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func listOfCitiesJSON() {
        
        if let path = Bundle.main.path(forResource: "cityList", ofType: "json") {
            let fileUrl = URL(fileURLWithPath: path)
            do {
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                let cities = try JSONDecoder().decode(Array<City>.self, from: data)
                self.cities = cities
                for i in cities {
                    self.testArr.append("\(i.name), \(i.country), \(i.id)") // , \(i.country), \(i.id)
                }
                
            } catch let error {
                print(error)
            }
        }
    }
    
}
