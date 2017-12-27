//
//  Double+Temprature.swift
//  WeatherApp
//
//  Created by Jebamani, Sivaram [GCB-OT NE] on 12/26/17.
//  Copyright © 2017 Jebamani, Sivaram. All rights reserved.
//

import Foundation
extension Float {
    
    /// Math fo convert kelvin to celsius
    func kelvinToCelsius() -> Float {
        return self - 273.15
    }
    
    /// Math fo convert kelvin to Fahrenheit
    func kelvinToFahrenheit() -> Float {
        return self * 9 / 5 - 459.67
    }
    
}
