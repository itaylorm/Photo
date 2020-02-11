//
//  AssetManagerMock.swift
//  PhotoTests
//
//  Created by Taylor Maxwell on 2/10/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import UIKit
import Photos
@testable import Photo

class AssetManagerMock {
  
  var shouldReturnError = false
  var authorizationStatus = PHAuthorizationStatus.authorized
  
  func reset() {
    shouldReturnError = false
    authorizationStatus = PHAuthorizationStatus.authorized
  }

  convenience init() {
    self.init(false)
  }

  init(_ shouldReturnError: Bool) {
    self.shouldReturnError = shouldReturnError
  }
  
  let mockAssets: [PHAsset] =
  [
    PHAssetMock(pixelWidth: 3000, pixelHeight: 1900, creationDate: Date(), isFavorite: true),
    PHAssetMock(pixelWidth: 1000, pixelHeight: 3000, creationDate: Date(), isFavorite: true),
    PHAssetMock(pixelWidth: 3092, pixelHeight: 2000, creationDate: Date(), isFavorite: false)
  ]
  
  var mockAsset: PHAsset?
  
}

extension AssetManagerMock: AssetManagerProtocol {

  func requestImage(for asset: PHAsset,
                    targetSize: CGSize, contentMode: PHImageContentMode,
                    options: PHImageRequestOptions?,
                    resultHandler: @escaping (UIImage?, [AnyHashable: Any]?) -> Void) -> PHImageRequestID {
    return PHImageRequestID()
  }
  
  func fetchAssets(with mediaType: PHAssetMediaType, options: PHFetchOptions?) -> PHFetchResult<PHAsset> {
    let result = PHFetchResultMock(items: mockAssets)
    return result
  }
  
  func requestAuthorization(_ handler: @escaping (PHAuthorizationStatus) -> Void) {
    handler(authorizationStatus)
  }
  
  func requestContentEditingInput(with options: PHContentEditingInputRequestOptions?,
                                  asset: PHAsset,
                                  completionHandler: @escaping (PHContentEditingInput?, [AnyHashable: Any]) -> Void)
    -> PHContentEditingInputRequestID {
    return PHContentEditingInputRequestID()
  }
  
}
