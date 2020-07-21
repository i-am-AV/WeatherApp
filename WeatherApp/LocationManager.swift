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
    override init() {
        super.init()
        self.locationManager.delegate = self
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


// MARK: - CoreLocation Delegate
extension LocationManager: CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
    
        case .notDetermined         : print("notDetermined")        // location permission not asked for yet
        case .authorizedWhenInUse   : print("authorizedWhenInUse")  // location authorized
        case .authorizedAlways      : print("authorizedAlways")     // location authorized
        case .restricted            : print("restricted")           // TODO: handle
        case .denied                : print("denied")               // TODO: handle
        @unknown default:
            print("New Status")
        }
    }
}
