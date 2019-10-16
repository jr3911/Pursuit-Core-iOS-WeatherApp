//
//  DetailWeatherVC.swift
//  WeatherApp
//
//  Created by Jason Ruan on 10/10/19.
//  Copyright © 2019 David Rifkin. All rights reserved.
//

import UIKit

class DetailWeatherVC: UIViewController {
    //MARK: Properties
    var cityName: String!
    var dayForecast: DayForecast!
    var timezone: String!
    
    lazy var topLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    lazy var weatherIconImageView: UIImageView = {
        let imageview = UIImageView()
        return imageview
    }()
    
    lazy var weatherDetailsTextView: UITextView = {
        let tv = UITextView()
        tv.textAlignment = .left
        tv.font = .systemFont(ofSize: 15)
        tv.isEditable = false
        return tv
    }()
    
    //MARK: LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpViews()
        configureConstraints()
    }
    
    //MARK: Private Functions
    private func setUpViews() {
        setLabel()
        setImage()
        setTextView()
    }
    
    private func configureConstraints() {
        topLabelConstraints()
        iconImageViewConstraints()
        weatherDetailsTextViewConstraints()
    }
    
    private func setLabel() {
        view.addSubview(topLabel)
        
        let date = Date(timeIntervalSince1970: TimeInterval(dayForecast.time))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        topLabel.text = "Weather forecast for \(cityName!) for \(dateString)"
    }
    
    private func setImage() {
        view.addSubview(weatherIconImageView)
        if let iconImage = UIImage(named: dayForecast.icon) {
            weatherIconImageView.image = iconImage
        } else if dayForecast.icon == "partly-cloudy-day" {
            weatherIconImageView.image = UIImage(named: "pcloudy")
        } else if dayForecast.icon == "clear-day" {
            weatherIconImageView.image = UIImage(named: "clear")
        } else {
            weatherIconImageView.image = UIImage(named: "pcloudy")
        }
    }
    
    private func setTextView() {
        view.addSubview(weatherDetailsTextView)
        
        let sunriseTimeDate = Date(timeIntervalSince1970: TimeInterval(dayForecast.sunriseTime))
        let sunsetTimeDate = Date(timeIntervalSince1970: TimeInterval(dayForecast.sunsetTime))
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        dateFormatter.timeZone = TimeZone(abbreviation: timezone)
        
        let sunriseTime = dateFormatter.string(from: sunriseTimeDate)
        let sunsetTime = dateFormatter.string(from: sunsetTimeDate)
        
        weatherDetailsTextView.text = """
                \(dayForecast.summary)
        
        High: \(Int(dayForecast.temperatureHigh))°F
        Low: \(Int(dayForecast.temperatureLow))°F
        Sunrise: \(sunriseTime)
        Sunset: \(sunsetTime)
        Windspeed: \(Int(dayForecast.windSpeed)) MPH
        Inches of Precipitation: \(String(format: "%0.2f", dayForecast.precipIntensityMax))
        """
    }
    
    private func topLabelConstraints() {
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            topLabel.heightAnchor.constraint(equalToConstant: 30),
            topLabel.widthAnchor.constraint(equalToConstant: view.frame.width)
        ])
    }
    
    private func iconImageViewConstraints() {
        weatherIconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherIconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherIconImageView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 10),
            weatherIconImageView.heightAnchor.constraint(equalToConstant: view.frame.height / 3),
            weatherIconImageView.widthAnchor.constraint(equalTo: weatherIconImageView.heightAnchor)
        ])
    }
    
    private func weatherDetailsTextViewConstraints() {
        weatherDetailsTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherDetailsTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherDetailsTextView.topAnchor.constraint(equalTo: weatherIconImageView.bottomAnchor, constant: 10),
            weatherDetailsTextView.heightAnchor.constraint(equalToConstant: view.frame.height / 3),
            weatherDetailsTextView.widthAnchor.constraint(equalTo: weatherIconImageView.heightAnchor)
        ])
    }
    
}
