//
//  ViewController.swift
//  WeatherApp
//
//  Created by  Alexander on 21.07.2020.
//  Copyright © 2020  Alexander. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Property
    private let locationManager = LocationManager()
    
    //MARK: - Life cycle    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let location = locationManager.exposedLocation else { return }

        locationManager.getPlace(for: location) { placemark in
            guard let placemark = placemark else { return }

            var output = "Our location is: "
            if let town = placemark.locality {
                output = output + " \(town)"
            }
            print(output)
        }
    }
    
}

