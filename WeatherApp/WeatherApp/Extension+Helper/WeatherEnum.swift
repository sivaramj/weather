//
//  WeatherEnum.swift
//  WeatherApp
//
//  Created by Jebamani, Sivaram [GCB-OT NE] on 12/26/17.
//  Copyright © 2017 Jebamani, Sivaram. All rights reserved.
//

import Foundation
import UIKit

/// Enum used to check the time range (Morning/Evening/Night)
enum time {
    case morning
    case evening
    case night
    
    static func checkTime() -> time {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<17 : return .morning
        case 17..<20 : return .evening
        default: return .night
        }
    }
}

/// Enum used apply the background based on the time and weather type
enum backgroundImage: String {
    case clearSkyMorning = "ClearSky_Morning"
    case clearSkyEvening = "ClearSky_Evening"
    case clearSkyNight = "ClearSky_Night"
    case rainyNight = "Rain_Night"
    case rainyMorning = "Rain_Morning"
    case cloudy = "Cloudy"
    
    func getImage() -> UIImage {
        return UIImage(named: self.rawValue)!
    }
    
    static func getType(type: String, time: time) -> backgroundImage {
        let text = type.lowercased()
        if text.contains("clear") {
            switch time {
            case .morning:
                return .clearSkyMorning
            case .evening:
                return .clearSkyEvening
            case .night:
                return .clearSkyNight
            }
        } else if text.contains("rain") {
            switch time {
            case .morning:
                return .rainyMorning
            default:
                return .rainyNight
            }
        } else if text.contains("cloud") {
            return .cloudy
        }
        return .clearSkyMorning
    }
}
