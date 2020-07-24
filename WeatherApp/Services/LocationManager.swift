//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Игорь Силаев on 21.07.2020.
//  Copyright © 2020  Alexander. All rights reserved.
//

import Foundation
import CoreLocation


final class LocationManager: NSObject {
    
    //MARK: - Property
    private let locationManager = CLLocationManager()
    var exposedLocation: CLLocation? {
        return locationManager.location
    }
    
    //MARK: - Inizilization
    init(client: CLLocationManagerDelegate) {
        super.init()
        self.locationManager.delegate = client
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    //MARK: - Methods
    func getPlace(for location: CLLocation,
                  completion: @escaping (CLPlacemark?) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            
            guard error == nil else {
                print("*** Error: \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?[0] else {
                print("*** Error: placemark is nil")
                completion(nil)
                return
            }
            
            completion(placemark)
        }
    }
}
