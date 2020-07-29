//
//  WeatherVCObject.swift
//  WeatherApp
//
//  Created by  Alexander on 29.07.2020.
//  Copyright © 2020  Alexander. All rights reserved.
//

import UIKit

final class WeatherVCObject: CoreTestCase {
    
    func tapButton(with identifier: String) {
        app.buttons[identifier].tap()
    }
    
    func swipingTable(with identifier: String) {
        app.tables[identifier].swipeUp()
        app.tables[identifier].swipeDown()
        app.tables[identifier].swipeLeft()
        app.tables[identifier].swipeRight()
    }
}

