//
//  Model.swift
//  WeatherApp
//
//  Created by  Alexander on 22.07.2020.
//  Copyright © 2020  Alexander. All rights reserved.
//

import Foundation

struct Coord {
    let lon: Int
    let lat: Int
    let weather: [Weather]
    let base: String
    let main: [Main]
    let wind: [Wind]
    let clounds: [Clounds]
    let dt: Int
    let sys: [Sys]
    let id: Int
    let name: String
    let cod: Int
}

struct Weather {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Main {
    let temp: Double
    let pressure: Double
    let humidity: Int
    let tempMin: Double
    let tempMax: Double
    let seaLevel: Double
    let grndLevel: Double
}

struct Wind {
    let speed: Double
    let deg: Int
}

struct Clounds {
    let all: Int
}

struct Sys {
    let message: Double
    let country: String
    let sunrise: Int
    let sunset: Int
}
