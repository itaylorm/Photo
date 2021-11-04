//
//  ImageManager.swift
//  Photo
//
//  Created by Taylor Maxwell on 2/10/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import UIKit
import Photos

protocol PHAssetProtocol: AnyObject {
  var pixelWidth: Int { get set }
  var pixelHeight: Int { get set }
  var creationDate: Date? { get set }
}

protocol AssetManagerProtocol {
  
  @discardableResult
  func requestImage(for asset: PHAsset, targetSize: CGSize, contentMode: PHImageContentMode,
                    options: PHImageRequestOptions?, resultHandler: @escaping (UIImage?, [AnyHashable: Any]?) -> Void) -> PHImageRequestID
  
  func fetchAssets(with mediaType: PHAssetMediaType, options: PHFetchOptions?) -> PHFetchResult<PHAsset>
  
  func requestAuthorization(_ handler: @escaping (PHAuthorizationStatus) -> Void)
  
  @discardableResult
  func requestContentEditingInput(
    with options: PHContentEditingInputRequestOptions?,
    asset: PHAsset, completionHandler: @escaping (PHContentEditingInput?, [AnyHashable: Any]) -> Void) -> PHContentEditingInputRequestID
  
  func getCIImage(contentsOf: URL) -> CIImage?
  
}

class AssetManager: AssetManagerProtocol {
  
  func requestImage(for asset: PHAsset, targetSize: CGSize, contentMode: PHImageContentMode,
                    options: PHImageRequestOptions?, resultHandler: @escaping (UIImage?, [AnyHashable: Any]?) -> Void) -> PHImageRequestID {
    
    return PHImageManager.default()
      .requestImage(for: asset, targetSize: targetSize,
                    contentMode: contentMode, options: options) { (image, hashable) in
      resultHandler(image, hashable)
    }
  }
  
  func fetchAssets(with mediaType: PHAssetMediaType, options: PHFetchOptions?) -> PHFetchResult<PHAsset> {
    return PHAsset.fetchAssets(with: mediaType, options: options)
  }
  
  func requestAuthorization(_ handler: @escaping (PHAuthorizationStatus) -> Void) {
    PHPhotoLibrary.requestAuthorization { (authStatus: PHAuthorizationStatus) -> Void in
      handler(authStatus)
    }
  }
  
  func requestContentEditingInput(
    with options: PHContentEditingInputRequestOptions?,
    asset: PHAsset, completionHandler: @escaping (PHContentEditingInput?, [AnyHashable: Any]) -> Void) -> PHContentEditingInputRequestID {
    return asset.requestContentEditingInput(with: options) { (contentEditingInput: PHContentEditingInput?, hashable) in
      completionHandler(contentEditingInput, hashable)
    }
  }
  
  func getCIImage(contentsOf url: URL) -> CIImage? {
    return CIImage(contentsOf: url)
  }
}
