//
//  WeatherAppUITests.swift
//  WeatherAppUITests
//
//  Created by Игорь Силаев on 28.07.2020.
//  Copyright © 2020  Alexander. All rights reserved.
//

import XCTest

class WeatherAppUITests: XCTestCase {
    
    private let weatherVCObject = WeatherVCObject()
    private let citySearchVCObject = CitySearchVCObject()
    private let app = XCUIApplication()

    override func setUpWithError() throws {
        
        continueAfterFailure = false

    }

    override func tearDownWithError() throws {
        
    }

    func testCitySearchViewController() throws {
        app.launch()
        
        citySearchVCObject.tapAddButton(with: "Add button")
        citySearchVCObject.tapSearchField(with: "Search City")
        citySearchVCObject.tapCell(with: "Amsterdam")
        citySearchVCObject.tapCancelButton(with: "Cancel")
        
//        let addButton = app.buttons["Add button"]
//        let cityNavigation = app.navigationBars["City navigation"]
//        let searchField = cityNavigation.searchFields["Search City"]
//        let cityTable = app.tables["City table"]
//        
//        addButton.tap()
//        
//        searchField.tap()
//        
//        XCTAssertFalse(app.isOnMainViewController)
//        
//        cityNavigation.buttons["Cancel"].tap()
//        
//        cityTable.cells["Amsterdam"].tap()

    }
    
    func testWeatherViewController() throws {
        app.launch()
        
        XCTAssertTrue(app.isOnMainViewController)
        weatherVCObject.swipingTable(with: "TableView")
        weatherVCObject.tapButton(with: "Add button")
    }
}

extension XCUIApplication {
    var isOnMainViewController: Bool {
        return otherElements["MainViewController"].exists
    }
}
