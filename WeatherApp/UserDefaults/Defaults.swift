//
//  Defaults.swift
//  WeatherApp
//
//  Created by  Alexander on 23.07.2020.
//  Copyright © 2020  Alexander. All rights reserved.
//

import Foundation

struct Defaults {
    
    private var city = CityStruct()
    
    mutating func save(name: String) {
        if !city.names.contains(name) {
            city.names.append(name)
        }
    }
    
    func getData() -> [String] {
        return city.names
    }
    
    func clearData() {
        city.clear()
    }
}

 private struct CityStruct {
    
    private enum Keys: String {
        case name
    }
    private let userDefaults = UserDefaults.standard
    
    var names: [String] {
        
        get {
            return userDefaults.object(forKey: Keys.name.rawValue) as? [String] ?? []
        }
        
        set {
            userDefaults.set(newValue, forKey: Keys.name.rawValue)
            userDefaults.synchronize()
        }
    }
    
    
    func clear() {
        userDefaults.removeObject(forKey: Keys.name.rawValue)
        userDefaults.synchronize()
    }
}
