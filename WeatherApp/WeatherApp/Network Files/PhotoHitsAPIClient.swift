//
//  PhotoHitsAPIClient.swift
//  WeatherApp
//
//  Created by Jason Ruan on 10/16/19.
//  Copyright © 2019 David Rifkin. All rights reserved.
//

import Foundation

class PhotoHitsAPIClient {
    private init() {}
    static let manager = PhotoHitsAPIClient()
    
    func getPhotoHits(searchTerm: String, completionHandler: @escaping (Result<[Photo], AppError>) -> () ) {
        let urlString = "https://pixabay.com/api/?key=\(Secrets().pixabayAPIKey)&q=\(searchTerm)&image_type=photo"
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.badURL))
            return
        }
        
        NetworkHelper.manager.performDataTask(withUrl: url, andMethod: .get) { (result) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
                return
            case .success(let data):
                do {
                    let photoHits = try JSONDecoder().decode(PhotoHits.self, from: data)
                    completionHandler(.success(photoHits.hits))
                } catch {
                    completionHandler(.failure(.couldNotParseJSON(rawError: error)))
                }
            }
        }
    }
}
