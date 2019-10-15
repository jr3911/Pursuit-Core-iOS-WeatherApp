//
//  Weather.swift
//  WeatherApp
//
//  Created by Jason Ruan on 10/10/19.
//  Copyright © 2019 David Rifkin. All rights reserved.
//

import Foundation

struct CityAndForecast: Codable {
    let name: String
    let cityInfo: City
}

struct City: Codable {
    let latitude: Double
    let longitude: Double
    let timezone: String
    let daily: DailyWrapper
}


struct DailyWrapper: Codable {
    let summary: String
    let icon: String
    let data: [DayForecast]
}


struct DayForecast: Codable {
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
