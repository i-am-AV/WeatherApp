//
//  ImageViewExtension.swift
//  WeatherApp
//
//  Created by  Alexander on 24.07.2020.
//  Copyright © 2020  Alexander. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func configuration() {
        self.image = #imageLiteral(resourceName: "sun")
        self.contentMode = .scaleAspectFit
    }
}
