//
//  CoreDataInterface.swift
//  WeatherApp
//
//  Created by  Alexander on 23.07.2020.
//  Copyright © 2020  Alexander. All rights reserved.
//

import Foundation

protocol CoreDataInterface {
    func save(city: String, and temperature: Double)
    func fetchRequest()
    func citiesCount() -> Int?
}
