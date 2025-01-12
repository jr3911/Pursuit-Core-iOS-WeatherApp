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
    let defaults = UserDefaults.standard
    
    var cityAndForecast: CityAndForecast? {
        didSet {
            if let forecast = self.cityAndForecast?.cityInfo.daily.data {
                dailyForecast = forecast
            }
            if let cityName = self.cityAndForecast?.name {
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
        if let cityName = self.cityAndForecast?.name {
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
    
        loadSubviews()
        configureSubviewConstraints()
        
        loadDefaultZipcode()
        
        loadForecast()
        
    }
    
    
    //MARK: Private Functions
    private func loadDefaultZipcode() {
        if let zipcode = defaults.object(forKey: "Zipcode") as? String {
            searchInput = zipcode
            searchBar.text = zipcode
        }
    }
    
    private func loadSubviews() {
        view.addSubview(cityLabel)
        view.addSubview(forecastCollectionView)
        view.addSubview(searchBar)
        view.addSubview(enterZipLabel)
    }
    
    private func configureSubviewConstraints() {
        cityLabelConstraints()
        forecastCollectionViewConstraints()
        searchBarConstraints()
        enterZipLabelConstraints()
    }
    
    private func loadForecast() {
        if let zipcode = self.searchInput {
            ForecastAPIClient.manager.getForecast(zipcode: zipcode) { (result) in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let cityInfo):
                    self.cityAndForecast = cityInfo
                    self.defaults.set(zipcode, forKey: "Zipcode")
                }
            }
        }
    }
    
    //MARK: Constraints
    private func cityLabelConstraints() {
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cityLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            cityLabel.widthAnchor.constraint(equalTo: view.widthAnchor),
            cityLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func forecastCollectionViewConstraints() {
        forecastCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            forecastCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            forecastCollectionView.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 40),
            forecastCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            forecastCollectionView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func searchBarConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchBar.topAnchor.constraint(equalTo: forecastCollectionView.bottomAnchor, constant: 30),
            searchBar.widthAnchor.constraint(equalToConstant: view.frame.width / 3),
            searchBar.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func enterZipLabelConstraints() {
        enterZipLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            enterZipLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            enterZipLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 25),
            enterZipLabel.widthAnchor.constraint(equalToConstant: view.frame.width / 3),
            enterZipLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
}

//MARK: CollectionView Methods
extension MainWeatherVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dailyForecast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weatherCell", for: indexPath) as! WeatherCollectionViewCell
        let selectedForecast = dailyForecast[indexPath.row]
        
        let date = Date(timeIntervalSince1970: TimeInterval(selectedForecast.time))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        cell.dateLabel.text = dateString
        cell.highLabel.text = "High: \(selectedForecast.temperatureHigh)°F"
        cell.lowLabel.text = "Low: \(selectedForecast.temperatureLow)°F"
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailWeatherVC()
        detailVC.cityName = self.cityAndForecast?.name
        detailVC.dayForecast = self.dailyForecast[indexPath.row]
        detailVC.timezone = self.cityAndForecast?.cityInfo.timezone
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

//MARK: SearchBar Delegate
extension MainWeatherVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchInput = searchBar.text
        searchBar.resignFirstResponder()
    }
}
