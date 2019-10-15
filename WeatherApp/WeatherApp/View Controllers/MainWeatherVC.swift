//
//  MainWeatherVC.swift
//  WeatherApp
//
//  Created by Jason Ruan on 10/10/19.
//  Copyright © 2019 David Rifkin. All rights reserved.
//

import UIKit

class MainWeatherVC: UIViewController {
    //MARK: Properties
    var cityAndForecast: (String, City)? {
        didSet {
            if let forecast = self.cityAndForecast?.1.daily.data{
                dailyForecast = forecast
            }
            if let cityName = self.cityAndForecast?.0 {
                cityLabel.text = "Weather forecast for \(cityName)"
            }
        }
    }
    
    private var dailyForecast = [DayForecast]() {
        didSet {
            forecastCollectionView.reloadData()
        }
    }
    
    private var searchInput: String? {
        didSet {
            loadForecast()
        }
    }
    
    lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        if let cityName = self.cityAndForecast?.0 {
            label.text = "Weather forecast for \(cityName)"
        } else {
            label.text = "Enter a zip code for the weather forecast"
        }
        return label
    }()
    
    lazy var forecastCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: 200)
        
        let cv = UICollectionView(frame: CGRect(origin: CGPoint(x: 0, y: 200), size: CGSize(width: self.view.frame.width, height: 200)), collectionViewLayout: layout)
        
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = .white
        
        return cv
    }()
    
    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.delegate = self
        bar.barStyle = .default
        bar.keyboardType = .default
        return bar
    }()
    
    lazy var enterZipLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Enter a Zip Code"
        return label
    }()
    
    //MARK: LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Search"
        
        let nib = UINib(nibName: "WeatherCollectionViewCell", bundle: nil)
        forecastCollectionView.register(nib, forCellWithReuseIdentifier: "weatherCell")
    }
    
    
}

extension MainWeatherVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dailyForecast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weatherCell", for: indexPath) as! WeatherCollectionViewCell
        let selectedForecast = dailyForecast[indexPath.row]
        cell.dateLabel.text = selectedForecast.time.description
        cell.highLabel.text = "High: \(selectedForecast.temperatureHigh)°F"
        cell.lowLabel.text = "Low: \(selectedForecast.temperatureLow)°F"
        print(indexPath.row, selectedForecast.icon)
        
        if let iconImage = UIImage(named: selectedForecast.icon) {
            cell.weatherIcon.image = iconImage
        } else if selectedForecast.icon == "partly-cloudy-day" {
            cell.weatherIcon.image = UIImage(named: "pcloudy")
        } else if selectedForecast.icon == "clear-day" {
            cell.weatherIcon.image = UIImage(named: "clear")
        } else {
            cell.weatherIcon.image = UIImage(named: "pcloudy")
        }
        
        return cell
    }
    
    
}

//MARK: SearchBar Delegate
extension MainWeatherVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchInput = searchBar.text
    }
}
