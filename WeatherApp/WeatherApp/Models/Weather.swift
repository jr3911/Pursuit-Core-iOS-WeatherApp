//
//  Weather.swift
//  WeatherApp
//
//  Created by Jason Ruan on 10/10/19.
//  Copyright © 2019 David Rifkin. All rights reserved.
//

import Foundation

struct Weather: Codable {
    let latitude: Double
    let longitude: Double
    let timezone: String
    let daily: DailyWrapper
    
    struct DailyWrapper: Codable {
        let summary: String
        let icon: String
        let data: [DataWrapper]
        
        struct DataWrapper: Codable {
            let time: Int
            let summary: String
            let icon: String
            let sunriseTime: Int
            let sunsetTime: Int
            let precipIntensityMax: Double
            let temperatureHigh: Double
            let temperatureLow: Double
            let windSpeed: Double
        }
    }
}
