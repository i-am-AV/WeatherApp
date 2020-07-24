//
//  CitySearchViewController.swift
//  WeatherApp
//
//  Created by  Alexander on 21.07.2020.
//  Copyright © 2020  Alexander. All rights reserved.
//

import UIKit

final class CitySearchViewController: UIViewController {
    
    //MARK: - Properties
    
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    private var cities: [String] = []
    private var filteredCities: [String] = []
    private let context = CoreDataStack().persistentContainer.viewContext
    private var defaults = Defaults()
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    //MARK: - Constants
    
    private enum Constants: String {
        case cellId
        case title = "Cities List"
        case placeholder = "Search City"
        case fileName = "Cities"
        case fileType = "txt"
    }
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dismiss(animated: true, completion: nil)
        view.backgroundColor = .white
        configurateNavigation()
        view.addSubview(tableView)
        configurateTableView()
        setTableViewConstraints()
        configurateSearchController()
        
        readFromFile(name: Constants.fileName.rawValue,
                     ofType: Constants.fileType.rawValue)
    }
    
    
    
    private func readFromFile(name: String, ofType: String) {
        if let path = Bundle.main.path(forResource: name, ofType: ofType) {
            if let citiesList = try? String(contentsOfFile: path) {
                cities = citiesList.components(separatedBy: "\n").filter({$0 != ""}).sorted()
                print("\(cities.count)" + "\(cities)")
            }
        }
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredCities = cities.filter { (city) -> Bool in
            return city.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
}


//MARK: - TableView Protocols Implementation

extension CitySearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredCities.count
        }
        
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellId.rawValue, for: indexPath)
        if isFiltering {
            cell.textLabel!.text = filteredCities[indexPath.row]
        } else {
            cell.textLabel!.text = cities[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cityName = cities[indexPath.row]
        defaults.save(name: cityName)
        tableView.reloadData()
        
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - SearchController Protocols Implementation

extension CitySearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}

//MARK: - Configurations & Constraints

extension CitySearchViewController {
    private func configurateSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Constants.placeholder.rawValue
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func configurateNavigation() {
        navigationItem.title = Constants.title.rawValue
    }
    
    private func configurateTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellId.rawValue)
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setTableViewConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}
