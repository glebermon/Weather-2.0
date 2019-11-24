//
//  FavoriteViewController.swift
//  Clima
//
//  Created by Глеб on 17.11.2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol FavoriteViewControllerDelegate {
    func userChoseFavoriteCity(cityId : Int)
}

class FavoriteViewController: UIViewController, ChangeCityDelegate {

    private var weathersData: [WeatherData] = []
        
    private var citiesArray = [String]()
    
    var cityName = ""
    
    private let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Cities.plist")
    
    var newCityDelegate : FavoriteViewControllerDelegate?
    
    let netService = NetworkService()
    var weatherAlamoData = [WeatherDataModelNew]()
    
    let table : TableView = {
       let table = TableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .clear
        return table
    }()
    
    private var refreshControl : UIRefreshControl = {
       let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        setupNavigationBar()
        loadData()
        getWeatherData()
    }
    
    func getWeatherData() {
        
        let params : [String : String] = [  "id" : "524901,703448,2643743"
                                           ,"appid" : API.APP_ID
                                           ,"units" : API.unitsMetric
                                        ]
        
        netService.loadWeatherAlamofire(parameters: params) { [weak self] (weathers, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let weathers = weathers, let self = self else { return }
            self.weatherAlamoData = weathers
                        
        }
    }
    
    @objc private func refresh() {
        weathersData = []
        loadData()
//        updateWeatherInfo()
        refreshControl.endRefreshing()
//        table.reloadData()
        
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = .black
        navigationItem.title = "Favorite"
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.backgroundColor = UIColor(white: 0.14, alpha: 0.98)
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.setLeftBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewFaviriteItem)), animated: true)
    }
    
    @objc func addNewFaviriteItem() {
        performSegue(withIdentifier: "changeCityName2", sender: self)
    }
    
    func setupTable() {
        view.backgroundColor = UIColor(white: 0.3, alpha: 0.7)
        
        view.addSubview(table)
        table.dataSource = self
        table.tableDelegate = self
        table.separatorStyle = .none
        table.backgroundColor = .clear
        
        table.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        table.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        table.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        table.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        table.refreshControl = refreshControl
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName2" {
            let destVC = segue.destination as! ChangeCityViewController
            destVC.delegate = self
            destVC.segueId = "123"
        }
    }
    
    func userEnteredANewCityName(city: String) {
        if !citiesArray.contains(city) {
            citiesArray.append(city)
            saveDate()
        }
        updateWeatherInfo()
    }
}

extension FavoriteViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weathersData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.reuseId, for: indexPath) as! FavoriteTableViewCell
        
        let weather = weathersData[indexPath.row]
        let tempreture = String(Int(weather.main.temp)) + "\u{00B0}"
        let weatherIcon = WeatherDataModel.updateWeatherIcon(condition: weather.weather[0].id)
        cell.cityLabel.text = weather.name
        cell.temperatureLabel.text = tempreture
        cell.weatherIcon.image = UIImage(named: weatherIcon)
        
        
        
        return cell
    }
}

extension FavoriteViewController {
    private func updateWeatherInfo() {
        let session = URLSession.shared
        var citiesString = ""
        if citiesArray.count < 1 {
            print("no element to delete")
        } else {
            citiesString = citiesArray.joined(separator: ",")
        }
        
        let url = URL(string: "http://api.openweathermap.org/data/2.5/group?id=\(citiesString)&units=metric&APPID=397524c94e750007153260c0960f6c05")!
        let task = session.dataTask(with: url) { [weak self] (data, responds, error) in
            
            guard let data = data else { return }
            do {
//                let str = String(decoding: data, as: UTF8.self)
//                print(str)
                
                //Не декодится, потому что в decode передается класс, а не экземпляр класса
                let response = try JSONDecoder().decode(WeatherResponse.self, from: data)
                guard let weathers = response.weathersData else { return }
                self?.weathersData = weathers
                DispatchQueue.main.async {
                    self?.table.reloadData()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}

extension FavoriteViewController {
    
    func saveDate() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(citiesArray)
            try data.write(to: dataFilePath!)
        } catch {
            print(error.localizedDescription)
        }
        self.table.reloadData()
    }
    
    func loadData() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                citiesArray = try decoder.decode([String].self, from: data)
            } catch {
                print(error.localizedDescription)
            }
        }
        updateWeatherInfo()
        self.table.reloadData()
    }
}

extension FavoriteViewController : TableViewDelegate {
    func deleteRowAtIndexPath(indexPath: IndexPath) {
        weathersData.remove(at: indexPath.row)
        citiesArray.remove(at: indexPath.row)
        table.deleteRows(at: [indexPath], with: .fade)
        saveDate()
    }
    
    func didSelectItem(item: Int) {
        let cityName = weathersData[item].id
        print("\n" + #function)
        print("данные переданы из Table View. Номер строки: \(item), id города: \(weathersData[item].id) \n")
        newCityDelegate?.userChoseFavoriteCity(cityId: cityName)
        self.dismiss(animated: true, completion: nil)
    }
}
