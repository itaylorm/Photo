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

    func getPhotos(page: Int, completed: @escaping(Result<[PhotoViewModel], IMError>) -> Void) {
        
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
    
    private func getImagesFromPhotoLibrary(page: Int) -> [PhotoViewModel] {
        var images = [PhotoViewModel]()
        let imgManager = PHImageManager.default()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        if !fetchResult.isEmpty() {
            
            let totalPhotos = fetchResult.count
            let startIndex = (itemCountPerPage * (page - 1)) + (page == 1 ? 0 : 1)
            var endIndex = itemCountPerPage * page
            
            if startIndex > totalPhotos { return images }
            if endIndex > totalPhotos { endIndex = totalPhotos - 1 }
            
            for imageIndex in startIndex...endIndex {
                let asset = fetchResult.object(at: imageIndex)
                 imgManager.requestImage(for: asset,
                                         targetSize: CGSize(width: 500, height: 500),
                                         contentMode: .aspectFill, options: requestOptions) { (image, _) in
                     if let image = image {
                        images.append(PhotoViewModel(asset: asset, image: image))
                     }

                 }
             }
        }
        return images
    }
}
