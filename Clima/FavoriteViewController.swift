//
//  FavoriteViewController.swift
//  Clima
//
//  Created by Глеб on 17.11.2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire

protocol FavoriteViewControllerDelegate {
    func userChoseFavoriteCity(cityId : Int)
}

class FavoriteViewController: UIViewController, ChangeCityDelegate {

    private var weathersData: [WeatherData] = []
        
    private var citiesArray = [String]()
    
    var cityName = ""
    
    private let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Cities.plist")
    
    var newCityDelegate : FavoriteViewControllerDelegate?
    
    let table : TableView = {
       let table = TableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .clear
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
//        print(dataFilePath)
        setupTable()
        setupNavigationBar()
        view.backgroundColor = UIColor(white: 0.3, alpha: 0.7)
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Favorite"
        
        navigationItem.setLeftBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewFaviriteItem)), animated: true)
    }
    
    @objc func addNewFaviriteItem() {
        performSegue(withIdentifier: "changeCityName2", sender: self)
    }
    
    func setupTable() {
        view.addSubview(table)
        table.dataSource = self
        table.tableDelegate = self
        table.separatorStyle = .none
        table.backgroundColor = .clear
        table.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        table.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        table.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        table.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
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
        
        cell.cityLabel.text = weathersData[indexPath.row].name
        
        return cell
    }
}

extension FavoriteViewController {
    private func updateWeatherInfo() {
        let session = URLSession.shared
        var citiesString = ""
        if citiesArray.count < 1 {
//            citiesString = "707860"
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
        print(#function)
        print("данные переданы из Table View. Номер строки: \(item), id города: \(weathersData[item].id)")
        newCityDelegate?.userChoseFavoriteCity(cityId: cityName)
        self.dismiss(animated: true, completion: nil)
    }
}
