//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Игорь Силаев on 22.07.2020.
//  Copyright © 2020  Alexander. All rights reserved.
//

import Foundation
import Alamofire

final class NetworkManager {
    
    //MARK: - Properties
    private let weatherURL = "https://api.openweathermap.org/data/2.5/weather"
    private let weatherAPIKey = "bd5ac2232bd727451b6e7146911a3ea5"
    
    // MARK: - Methods
    func getWeatherByCity(city: String, completion: @escaping (WeatherAPI) -> Void) {
        
        let request = AF.request("\(weatherURL)?q=\(city)&appid=\(weatherAPIKey)")
        
        request.responseDecodable(of: WeatherAPI.self) { response in
            guard let weather = response.value else {
                //TODO: - Error handler
                print("No such city")
                return
            }
            completion(weather)
        }
    }
}
