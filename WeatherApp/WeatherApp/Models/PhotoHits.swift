//
//  Photo.swift
//  WeatherApp
//
//  Created by Jason Ruan on 10/16/19.
//  Copyright © 2019 David Rifkin. All rights reserved.
//

import Foundation

struct PhotoHits: Codable {
    let hits: [Photo]
}

struct Photo: Codable {
    let largeImageURL: URL
}
