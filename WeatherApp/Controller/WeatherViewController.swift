//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by  Alexander on 21.07.2020.
//  Copyright © 2020  Alexander. All rights reserved.
//

import UIKit
import CoreData

final class WeatherViewController: UIViewController {
    
    //MARK: - Properties
    
    private let stackView = UIStackView()
    private let tableView = UITableView()
    private let cityLabel = UILabel()
    private let temperatureLabel = UILabel()
    
    private var addedCities: [String] = [Constants.defaultCity.rawValue]
    
    private let networkManager = NetworkManager()
    private let context = CoreDataStack().persistentContainer.viewContext
    private let defaults = Defaults()
    //MARK: - Constants
    
    private enum Constants: String {
        case cellId
        case title = "Weather"
        case defaultCity = "Moscow"
        case entityName = "City"
    }
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurateView()

        
            networkManager.getWeatherByCity(city: Constants.defaultCity.rawValue) { weather in
                print(weather.name)
                self.cityLabel.text = weather.name
                self.temperatureLabel.text = String(format: "%.0f", weather.main.tempCelsius) + "°"
                self.save(city: weather.name, and: weather.main.tempCelsius)
        }

        // TODO: - First app launch location

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addedCities =  Set(addedCities + defaults.getData()).sorted()
        
        tableView.reloadData()
        print(addedCities)
    }
}

//MARK: - TableView Protocols Implementation

extension WeatherViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        addedCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellId.rawValue, for: indexPath)
        
        cell.textLabel?.text = addedCities[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let city = addedCities[indexPath.row]
        
        networkManager.getWeatherByCity(city: city) { (weather) in
            self.cityLabel.text = weather.name
            self.temperatureLabel.text = String(format: "%.0f", weather.main.tempCelsius) + "°"
            self.save(city: weather.name, and: weather.main.tempCelsius)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - CoreData Implementation

extension WeatherViewController: CoreDataInterface {
    
    internal func save(city: String, and temperature: Double) {
        guard let entity = NSEntityDescription.entity(forEntityName: Constants.entityName.rawValue, in: self.context) else { return }
        let cityObject = City(entity: entity, insertInto: self.context)
        cityObject.name = city
        cityObject.temperature = temperature
        
        do {
            try self.context.save()
            print("Added city \(cityObject) in Core data")
            print(cityObject)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    internal func fetchRequest() {
        
        let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
        
        do {
            let city = try context.fetch(fetchRequest)
            print(city)
            
            cityLabel.text = city.first!.name
            temperatureLabel.text = String(format: "%.0f", city.first!.temperature) + "°"
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    internal func citiesCount() -> Int? {
        let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
        
        do {
            let city = try context.fetch(fetchRequest)
            return city.count
            
        } catch {
            print(error.localizedDescription)
            return nil
        }
        
    }
}

//MARK: - Configurations & Constraints

extension WeatherViewController {
    private func configurateView() {
        view.backgroundColor = .white
        
        configurateNavigation()
        
        view.addSubview(stackView)
        configurateStackView()
        setStackViewConstraints()
        
        view.addSubview(tableView)
        configurateTableView()
        setTableViewConstraints()
    }
    
    private func configurateNavigation() {
        navigationItem.title = Constants.title.rawValue
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addTapped))
    }
    
    @objc private func addTapped() {
        self.navigationController?.pushViewController(CitySearchViewController(),
                                                      animated: true)
    }
    
    private func configurateStackView() {
        
        cityLabel.configurateCityLabel()
        temperatureLabel.configurateTemperatureLabel()
        
        stackView.configuration()
        stackView.addArrangedSubview(cityLabel)
        stackView.addArrangedSubview(temperatureLabel)
    }
    
    private func setStackViewConstraints() {
        let indent: CGFloat = ((navigationController?.navigationBar.frame.height) ?? 0)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: indent),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func configurateTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellId.rawValue)
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setTableViewConstraints() {
        let height: CGFloat = view.frame.height
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.heightAnchor.constraint(equalToConstant: height / 2)
        ])
    }
}
