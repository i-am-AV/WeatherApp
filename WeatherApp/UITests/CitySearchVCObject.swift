//
//  CitySearchVCObject.swift
//  WeatherApp
//
//  Created by  Alexander on 29.07.2020.
//  Copyright © 2020  Alexander. All rights reserved.
//

import UIKit

final class CitySearchVCObject: CoreTestCase {
    
    func tapAddButton(with identifier: String) {
        let addButton = app.buttons[identifier]
        addButton.tap()
    }
    
    func tapCancelButton(with identifier: String) {
        let cancelButton = element?.buttons[identifier]
        cancelButton?.tap()
    }
    
    func tapSearchField(with identifier: String) {
        let searchField = element?.searchFields[identifier]
        searchField?.tap()
    }
    
    func tapCell(with identifier: String) {
        let cell = element?.cells[identifier]
        cell?.tap()
    }
}
