//
//  StackViewExtension.swift
//  WeatherApp
//
//  Created by  Alexander on 21.07.2020.
//  Copyright © 2020  Alexander. All rights reserved.
//

import UIKit

extension UIStackView {
    
    private enum Constants {
        static let spacing: CGFloat = -8
    }
    
    func configuration() {
        self.axis = .vertical
        self.alignment = .fill
        self.distribution = .fillProportionally
        self.spacing = Constants.spacing
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
