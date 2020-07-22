//
//  LabelExtension.swift
//  WeatherApp
//
//  Created by  Alexander on 21.07.2020.
//  Copyright © 2020  Alexander. All rights reserved.
//

import UIKit

extension UILabel {
    
    private enum Constant {
        static let cityTitle = "Current city"
        static let temperatureTitle = "0°"
        
        static let cityFont = UIFont.systemFont(ofSize: 25,
                                                weight: .regular)
        static let temperatureFont = UIFont.systemFont(ofSize: 150,
                                                       weight: .ultraLight)
    }
    
    func configurateCityLabel(with text: String = Constant.cityTitle, and font: UIFont = Constant.cityFont) {
        confidurateLabel(with: text, and: font)
    }
    
    func configurateTemperatureLabel(with text: String = Constant.temperatureTitle, and font: UIFont = Constant.temperatureFont) {
        confidurateLabel(with: text, and: font)
    }
    
    private func confidurateLabel(with text: String, and font: UIFont) {
        self.text = text
        self.font = font
        self.textAlignment = .center
        self.numberOfLines = 0
        self.translatesAutoresizingMaskIntoConstraints = true
    }
}