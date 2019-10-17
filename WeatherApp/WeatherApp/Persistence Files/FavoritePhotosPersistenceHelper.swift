//
//  FavoritePhotosPersistenceHelper.swift
//  WeatherApp
//
//  Created by Jason Ruan on 10/16/19.
//  Copyright © 2019 David Rifkin. All rights reserved.
//

import Foundation

struct FavoritePhotoPersistenceHelper {
    static let manager = FavoritePhotoPersistenceHelper()

    func save(newPhotoData: Data) throws {
        try persistenceHelper.save(newElement: newPhotoData)
    }

    func delete(indexOfElementTBDeleted: Int) throws {
        try persistenceHelper.delete(indexOfElementTBDeleted: indexOfElementTBDeleted)
    }
    
    func getFavoritePhotosData() throws -> [Data] {
        return try persistenceHelper.getObjects()
    }

    private let persistenceHelper = PersistenceHelper<Data>(fileName: "photos.plist")

    private init() {}
}

