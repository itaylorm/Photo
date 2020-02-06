//
//  PhotoManager.swift
//  Photo
//
//  Created by Taylor Maxwell on 2/6/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import UIKit
import Photos

class PhotoManager {
    static let shared = PhotoManager()
    
    let itemCountPerPage = 50
    
    private init() {}

    func getPhotos(page: Int, completed: @escaping(Result<[UIImage], IMError>) -> Void) {
        
        requestAccessToPhotos { (authorization: PHAuthorizationStatus) in
            switch authorization {
            case .authorized:
                let photos = self.getImagesFromPhotoLibrary(page: page)
                completed(.success(photos))
            case .denied:
                completed(.failure(.denied))
            case .notDetermined:
                completed(.failure(.notDetermined))
            case .restricted:
                completed(.failure(.restricted))
            @unknown default:
                completed(.failure(.unableToComplete))
            }
        }
        
    }
    
    private func requestAccessToPhotos(authClosure: @escaping (PHAuthorizationStatus) -> Void) {
        PHPhotoLibrary.requestAuthorization { (authStatus: PHAuthorizationStatus) -> Void in
            authClosure(authStatus)
        }
    }
    
    private func getImagesFromPhotoLibrary(page: Int) -> [UIImage] {
        var images = [UIImage]()
        let imgManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        if !fetchResult.isEmpty() {
            let startIndex = (itemCountPerPage * (page - 1)) + (page == 1 ? 0 : 1)
            let endIndex = itemCountPerPage * page
            for imageIndex in startIndex...endIndex {
                 imgManager.requestImage(for: fetchResult.object(at: imageIndex),
                                         targetSize: CGSize(width: 500, height: 500),
                                         contentMode: .aspectFill, options: requestOptions) { (image, _) in
                     if let image = image {
                         images.append(image)
                     }

                 }
             }
        }
        return images
    }
}
