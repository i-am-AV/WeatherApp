//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by  Alexander on 21.07.2020.
//  Copyright © 2020  Alexander. All rights reserved.
//

import UIKit

final class WeatherViewController: UIViewController {
    
    //MARK: - Properties
    
    private let stackView = UIStackView()
    private let tableView = UITableView()
    private let cityLabel = UILabel()
    private let temperatureLabel = UILabel()
    private var addedCities: [WeatherAPI] = []
    private let networkManager = NetworkManager()
    
    //MARK: - Constants
    
    private enum Constants: String {
        case cellId
        case title = "Weather"
    }
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurateView()
        // TODO: - First app launch location
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        networkManager.getWeatherByCity(city: "Moscow") { weather in
            self.cityLabel.text = weather.name
            self.temperatureLabel.text = String(format: "%.0f", weather.main.tempCelsius) + "°"
        }
        //TODO: load data & update table view & labels
    }
}

//MARK: - TableView Protocols Implementation

extension WeatherViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        addedCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellId.rawValue, for: indexPath)
        
        cell.textLabel?.text = addedCities[indexPath.row].name
        
        return UITableViewCell()
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
        navigationController?.pushViewController(CitySearchViewController(), animated: true)
    }
    
    private func configurateStackView() {
        
        cityLabel.configurateCityLabel()
        temperatureLabel.configurateTemperatureLabel()
        
        stackView.configuration()
        stackView.addArrangedSubview(cityLabel)
        stackView.addArrangedSubview(temperatureLabel)
    }
    
    private func setStackViewConstraints() {
        let indent: CGFloat = ((navigationController?.navigationBar.frame.height) ?? 0) + 32
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: indent),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func configurateTableView() {
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: Constants.cellId.rawValue)
        
        tableView.tableFooterView = UIView()
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
