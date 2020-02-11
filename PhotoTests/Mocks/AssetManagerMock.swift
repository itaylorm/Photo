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

enum ImageInformationStatus {
  case success
  case slrSuccess
  case missingExif
  case missingTiff
  case missingIptc
}

class AssetManagerMock {
  
  var shouldReturnError = false
  var authorizationStatus = PHAuthorizationStatus.authorized
  var imageInformationStatus = ImageInformationStatus.success
  
  func reset() {
    shouldReturnError = false
    authorizationStatus = PHAuthorizationStatus.authorized
    imageInformationStatus = ImageInformationStatus.success
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
      completionHandler(PHContentEditingInputMock(), [:])
    return PHContentEditingInputRequestID()
  }
  
  func getCIImage(contentsOf url: URL) -> CIImage? {
    let image = CIImageMock(contentsOf: url)
    switch imageInformationStatus {
    case .success:
      image?.configure(dictionary: createSuccessInformation())
    case .slrSuccess:
      image?.configure(dictionary: createSlrSuccessInformation())
    case .missingExif:
      image?.configure(dictionary: createInformationWithMissingExif())
    case .missingIptc:
      image?.configure(dictionary: createInformationWithMissingIPTC())
    case .missingTiff:
      image?.configure(dictionary: createInformationWithMissingTiff())
    }
    return image
  }
  
  private func createSuccessInformation() -> [String: Any?] {
    var dictionary: [String: Any?] = [:]
    dictionary[ImageKeys.exif.rawValue] = CIImageMock.iphoneExifDictionary
    dictionary[ImageKeys.tiff.rawValue] = CIImageMock.iphoneTiffDictionary
    dictionary[ImageKeys.iptc.rawValue] = CIImageMock.iptcDictionary
    return dictionary
  }
  
  private func createSlrSuccessInformation() -> [String: Any?] {
    var dictionary: [String: Any?] = [:]
    dictionary[ImageKeys.exif.rawValue] = CIImageMock.slrExifDictionary
    dictionary[ImageKeys.tiff.rawValue] = CIImageMock.slrTiffDictionary
    dictionary[ImageKeys.iptc.rawValue] = CIImageMock.iptcDictionary
    return dictionary
  }
  
  private func createInformationWithMissingExif() -> [String: Any?] {
    var dictionary: [String: Any?] = [:]
    dictionary[ImageKeys.tiff.rawValue] = CIImageMock.iphoneTiffDictionary
    dictionary[ImageKeys.iptc.rawValue] = CIImageMock.iptcDictionary
    return dictionary
  }
  
  private func createInformationWithMissingTiff() -> [String: Any?] {
    var dictionary: [String: Any?] = [:]
    dictionary[ImageKeys.exif.rawValue] = CIImageMock.iphoneExifDictionary
    dictionary[ImageKeys.iptc.rawValue] = CIImageMock.iptcDictionary
    return dictionary
  }
  
  private func createInformationWithMissingIPTC() -> [String: Any?] {
    var dictionary: [String: Any?] = [:]
    dictionary[ImageKeys.exif.rawValue] = CIImageMock.iphoneExifDictionary
    dictionary[ImageKeys.tiff.rawValue] = CIImageMock.iphoneTiffDictionary
    return dictionary
  }
}
