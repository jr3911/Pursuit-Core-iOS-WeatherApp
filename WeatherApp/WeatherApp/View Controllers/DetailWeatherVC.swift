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

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
