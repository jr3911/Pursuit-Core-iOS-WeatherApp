//
//  FavoritePhotosCollectionViewCell.swift
//  WeatherApp
//
//  Created by Jason Ruan on 10/16/19.
//  Copyright © 2019 David Rifkin. All rights reserved.
//

import UIKit

class FavoritePhotosCollectionViewCell: UICollectionViewCell {
    //MARK: Properties
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    //MARK: Init Functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFavoriteImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Private Functions
    private func setupFavoriteImageView() {
        self.contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
}
