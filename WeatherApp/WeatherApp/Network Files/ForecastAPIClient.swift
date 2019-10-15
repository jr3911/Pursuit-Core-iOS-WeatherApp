//
//  ForecastAPIClient.swift
//  WeatherApp
//
//  Created by Jason Ruan on 10/10/19.
//  Copyright © 2019 David Rifkin. All rights reserved.
//

import Foundation

class ForecastAPIClient {
    private init() {}
    static let manager = ForecastAPIClient()
    
    func getForecast(zipcode: String, completionHandler: @escaping (Result<CityAndForecast, AppError>) -> () ) {
        ZipCodeHelper.getLatLong(fromZipCode: zipcode) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case let .success((lat, long, cityName)):
                let urlString = "https://api.darksky.net/forecast/\(Secrets().apiKey)/\(lat),\(long)"
                guard let url = URL(string: urlString) else {
                    completionHandler(.failure(.badURL))
                    return
                }
                
                NetworkHelper.manager.performDataTask(withUrl: url, andMethod: .get) { (result) in
                    switch result {
                    case .failure(let error):
                        completionHandler(.failure(error))
                    case .success(let data):
                        do {
                            let cityInfo = try JSONDecoder().decode(City.self, from: data)
                            let cityAndForecastInfo = CityAndForecast(name: cityName, cityInfo: cityInfo)
                            completionHandler(.success((cityAndForecastInfo)))
                        } catch let error {
                            completionHandler(.failure(.couldNotParseJSON(rawError: error)))
                        }
                    }
                }
            }
        }
    }
    
}
