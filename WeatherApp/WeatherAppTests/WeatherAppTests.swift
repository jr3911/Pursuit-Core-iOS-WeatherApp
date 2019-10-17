//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Jason Ruan on 10/17/19.
//  Copyright © 2019 David Rifkin. All rights reserved.
//

import XCTest

class WeatherAppTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testZipcodeHelper() {
        let zipcode = "60613"   //zipcode for Chicago
        var latitude = 0.0
        var longitude = 0.0
        var cityName = ""
        
        let expectation = XCTestExpectation(description: "Get placemark info from zipcode")
        
        ZipCodeHelper.getLatLong(fromZipCode: zipcode) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure:
                    XCTFail("Could not get latitude, longitude, and city name for given zipcode")
                case .success(let (lat, long, name)):
                    latitude = lat
                    longitude = long
                    cityName = name
                    expectation.fulfill()
                }
            }
        }
        
        wait(for: [expectation], timeout: 10)
        
        XCTAssert((latitude == 41.9602366 && longitude == -87.6598733 && cityName == "Chicago"), """
            For given zipcode: 60613
            
            Latitude: \(latitude)
            Expected Latitude: 41.9602366
            
            Longitude: \(longitude)
            Expected Longitude: -87.6598733
            
            CityName: \(cityName)
            Expected CityName: Chicago
            """)
    }
    
    func testForecastAPIClient() {
        var cityName = ""
        var dailyForecast = [DayForecast]()
        
        let expectation = XCTestExpectation(description: "Get city name and 7-day forecast from zipcode")
        
        ForecastAPIClient.manager.getForecast(zipcode: "60613") { (result) in
            switch result {
            case .failure:
                XCTFail("Could not city name and forecast from given zipcode")
            case .success(let cityNameAndForecast):
                cityName = cityNameAndForecast.name
                dailyForecast = cityNameAndForecast.cityInfo.daily.data
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 10)
        
        XCTAssert(cityName == "Chicago" && dailyForecast.count >= 5, "City name: \(cityName), dailyForecast.count: \(dailyForecast.count)")
    }
    
    func testPhotoHitsAPIClient() {
        let searchTerm = "NewYork"
        var photoData: Data?
        
        let expectation = XCTestExpectation(description: "Get photo results for search term")
        PhotoHitsAPIClient.manager.getPhotoHits(searchTerm: searchTerm) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure:
                    XCTFail("Could not get photo objects from given searchterm")
                case .success(let photoArr):
                    guard let randomPhotoImageURL = photoArr.randomElement()?.largeImageURL else {
                        XCTFail("Could not get a random Photo object")
                        return
                    }
                    ImageHelper.shared.getImage(url: randomPhotoImageURL) { (result) in
                        DispatchQueue.main.async {
                            switch result {
                            case .failure:
                                XCTFail("Could not get url for random Photo object")
                            case .success(let photoUIImage):
                                let photoPNGData = photoUIImage.pngData()
                                photoData = photoPNGData
                                expectation.fulfill()
                            }
                        }
                    }
                }
            }
        }
        
        wait(for: [expectation], timeout: 10)
        
        XCTAssert(photoData != nil, "No photoDataReceived")
        
    }
    
    func testFileManager() {
        guard let cloudPhotoPNGData = UIImage(named: "cloudy")?.pngData() else {
            XCTFail("Could not convert image to pngData")
            return
        }
        
        var favPhotosAlbum = [Data]()
        
        do {
            try FavoritePhotoPersistenceHelper.manager.save(newPhotoData: cloudPhotoPNGData)
            favPhotosAlbum = try FavoritePhotoPersistenceHelper.manager.getFavoritePhotosData()
        } catch {
            XCTFail("Could not save pngData to File Manager")
        }
        
        
        
        XCTAssert(favPhotosAlbum.count > 0, "File Manager could not save pngData for retrieval")
    }
}
