//
//  FavoriteImagesVC.swift
//  WeatherApp
//
//  Created by Jason Ruan on 10/10/19.
//  Copyright © 2019 David Rifkin. All rights reserved.
//

import UIKit

class FavoriteImagesVC: UIViewController {
    //MARK: Properties
    var favoritePhotosData: [Data] = [] {
        didSet {
            photoCollectionView.reloadData()
        }
    }
    
    lazy var photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width, height: view.frame.width)
        
        let cv = UICollectionView(frame: CGRect(origin: CGPoint(x: 0, y: 200), size: CGSize(width: view.frame.width, height: view.frame.height)), collectionViewLayout: layout)
        
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = .white
        
        return cv
    }()
    
    
    //MARK: LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .magenta
        
        photoCollectionView.register(FavoritePhotosCollectionViewCell.self, forCellWithReuseIdentifier: "favoritePhotoCell")
        
        loadFavoriteImages()
        setUpObjects()
        setUpConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadFavoriteImages()
    }
    
    //MARK: Private Functions
    private func setUpObjects() {
        view.addSubview(photoCollectionView)
    }
    
    private func setUpConstraints() {
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photoCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photoCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            photoCollectionView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor)
        ])
    }
    
    private func loadFavoriteImages() {
        do {
            favoritePhotosData = try FavoritePhotoPersistenceHelper.manager.getFavoritePhotosData().reversed()
        } catch {
            print(error)
        }
    }
    
}

//MARK: CollectionView Methods
extension FavoriteImagesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoritePhotosData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoritePhotoCell", for: indexPath) as! FavoritePhotosCollectionViewCell
        cell.imageView.image = UIImage(data: favoritePhotosData[indexPath.row])
        return cell
    }
    
    
}
