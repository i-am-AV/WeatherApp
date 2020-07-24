//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by  Alexander on 21.07.2020.
//  Copyright © 2020  Alexander. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

final class WeatherViewController: UIViewController {
    
    //MARK: - Properties
    
    private let stackView = UIStackView()
    private let tableView = UITableView()
    private let cityLabel = UILabel()
    private let temperatureLabel = UILabel()
    
    var addedCities: [String] = []
    
    private let networkManager = NetworkManager()
    private var locationManager: LocationManager!
    //MARK: - Constants
    
    private enum Constants: String {
        case cellId
        case title = "Weather"
        case entityName = "City"
    }
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = LocationManager(client: self)
        configurateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
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

// MARK: - CoreLocation Delegate
extension WeatherViewController: CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("notDetermined")
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
            guard let location = locationManager.exposedLocation else {
                print("Location is nil")
                return
            }
            locationManager.getPlace(for: location) { (placemark) in
                guard let city = placemark?.locality?.applyingTransform(.toLatin, reverse: false) else { return }
                self.networkManager.getWeatherByCity(city: city) { weather in
                    self.cityLabel.text = weather.name
                    self.temperatureLabel.text = String(format: "%.0f", weather.main.tempCelsius) + "°"
                    self.addedCities.append(weather.name)
                    self.tableView.reloadData()
                }
            }
        case .authorizedAlways:
            print("authorizedAlways")
        case .restricted:
            print("restricted")           // TODO: handler
        case .denied:
            print("denied")               // TODO: handler
        @unknown default:
            print("New Status")
        }
    }
}
