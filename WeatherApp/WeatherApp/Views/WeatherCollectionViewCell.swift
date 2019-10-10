//
//  WeatherCollectionViewCell.swift
//  WeatherApp
//
//  Created by Jason Ruan on 10/10/19.
//  Copyright © 2019 David Rifkin. All rights reserved.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    //MARK: IBOutlets
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
