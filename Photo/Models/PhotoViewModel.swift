//
//  PhotoViewModel.swift
//  Photo
//
//  Created by Taylor Maxwell on 2/6/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import UIKit
import Photos

class PhotoViewModel: Hashable {
    static func == (lhs: PhotoViewModel, rhs: PhotoViewModel) -> Bool {
        return lhs.image == rhs.image
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(localIdentifier)
    }
    let asset: PHAsset
    let image: UIImage
    var location: CLLocation?
    let localIdentifier: String
    let creationDate: Date?
    let modificationDate: Date?
    let pixelHeight: Int
    let pixelWidth: Int
    let isFavorite: Bool
    let isHDR: Bool
    let isPanorama: Bool
    let isScreenShot: Bool
    let isLive: Bool
    let isDepthEffect: Bool
    
    init(asset: PHAsset, image: UIImage) {
        self.asset = asset
        self.image = image
        self.location = asset.location
        self.localIdentifier = asset.localIdentifier
        
        if let creationDate = asset.creationDate {
            self.creationDate = creationDate
        } else {
            self.creationDate = nil
        }

        if let modificationDate = asset.modificationDate {
            self.modificationDate = modificationDate
        } else {
            self.modificationDate = nil
        }
        
        self.pixelHeight = asset.pixelHeight
        self.pixelWidth = asset.pixelWidth
        self.isFavorite = asset.isFavorite
        
        let subMediaType = asset.mediaSubtypes
        isDepthEffect = subMediaType.contains(.photoDepthEffect)
        isHDR = subMediaType.contains(.photoHDR)
        isPanorama = subMediaType.contains(.photoPanorama)
        isScreenShot = subMediaType.contains(.photoScreenshot)
        isLive = subMediaType.contains(.photoLive)
    }
}
