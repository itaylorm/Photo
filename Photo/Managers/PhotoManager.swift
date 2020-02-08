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

  enum PhotoType {
    case forList
    case forInfo
  }
  
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
    
    let requestOptions = PHImageRequestOptions()
    requestOptions.isSynchronous = true
    requestOptions.deliveryMode = .fastFormat
    requestOptions.resizeMode = .fast
    
    let fetchOptions = PHFetchOptions()
    fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    
    //https://stackoverflow.com/questions/53098339/fetch-all-photos-from-library-based-on-creationdate-in-swift-faster-way
//    let startDate = Date.convertToNSDate(Date.create(year: 2018, month: 01, day: 01))!
//    let endDate = Date.convertToNSDate(Date.create(year: 2019, month: 12, day: 31))!
//    fetchOptions.predicate = NSPredicate(format: "creationDate > %@ AND creationDate < %@", startDate, endDate)
    let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
    if !fetchResult.isEmpty() {
      
      let totalPhotos = fetchResult.count
      let startIndex = (itemCountPerPage * (page - 1)) + (page == 1 ? 0 : 1)
      var endIndex = itemCountPerPage * page
      
      if startIndex > totalPhotos { return images }
      if endIndex > totalPhotos { endIndex = totalPhotos - 1 }
      
      for imageIndex in startIndex...endIndex {
        let asset = fetchResult.object(at: imageIndex) as PHAsset
        if let thumbNail = getPhoto(photoType: .forList, asset: asset) {
          images.append(PhotoViewModel(asset: asset, thumbNail: thumbNail))
        }
      }
    } else { print("Returned no records") }
    return images
  }

  func getPhoto(viewModel: PhotoViewModel) -> UIImage? {
    let image = getPhoto(photoType: .forInfo, asset: viewModel.asset)
    viewModel.image = image
    return image
  }
  
  private func getPhoto(photoType: PhotoType, asset: PHAsset) -> UIImage? {
    var photo: UIImage?
    let size = getPhotoSize(photoType: photoType, asset: asset)

    let options = PHImageRequestOptions()
    options.isSynchronous = true
    options.deliveryMode = .highQualityFormat
    options.resizeMode = .exact
    
    PHImageManager.default().requestImage(for: asset,
    targetSize: size,
    contentMode: .aspectFit, options: options) { (image, _) in
      if let image = image {
        photo = image
      } else {
        print("Failed to retrieve image")
      }
    }
    return photo
  }
  
  private func getPhotoSize(photoType: PhotoType, asset: PHAsset) -> CGSize {
    switch photoType {
    case .forInfo:
      var minRatio: CGFloat = 1
      if CGFloat(asset.pixelWidth) > UIScreen.main.bounds.width || CGFloat(asset.pixelHeight) > UIScreen.main.bounds.height {
        minRatio = min(UIScreen.main.bounds.width/(CGFloat(asset.pixelWidth)), (UIScreen.main.bounds.height/CGFloat(asset.pixelHeight)))
      }
      return CGSize(width: CGFloat(asset.pixelWidth) * minRatio, height: CGFloat(asset.pixelHeight) * minRatio)
    case .forList:
      return CGSize(width: CGFloat(asset.pixelWidth) * 0.01, height: CGFloat(asset.pixelHeight) * 0.1)
    }
  }
  
  func getPhotoInformation(viewModel: PhotoViewModel, completed: @escaping(Result<PhotoViewModel, IMError>) -> Void) {
    
    let options = PHContentEditingInputRequestOptions()
    options.isNetworkAccessAllowed = true
    viewModel.asset.requestContentEditingInput(with: options) { (contentEditingInput: PHContentEditingInput?, _) in
      
      guard let url = contentEditingInput?.fullSizeImageURL, let fullImage = CIImage(contentsOf: url) else {
        completed(.failure(.unableToComplete))
        return
      }
      //print(fullImage.properties)
//      if let profileName = fullImage.properties["ProfileName"] {
//        //print(profileName)
//      } else {
//        print("Profile Name Not Found")
//      }
      
      // Does not work yet
      if let iso = fullImage.properties["ISOSpeedRatings"] {
        print(iso)
      }
      
      if let iptc = fullImage.properties["{IPTC}"], let iptcDictionary = iptc as? [String: Any?] {
        print(iptcDictionary)
      } else {
        print("IPTC Not Found")
      }

      if let tif = fullImage.properties["{TIFF}"], let tiffDictionary = tif as? [String: Any?] {
        self.getValue(dictionary: tiffDictionary, keyName: "Make", displayName: "Make: ")
        self.getValue(dictionary: tiffDictionary, keyName: "Model", displayName: "Model: ")
        self.getValue(dictionary: tiffDictionary, keyName: "YResolution", displayName: "YResolution: ")
        self.getValue(dictionary: tiffDictionary, keyName: "XResolution", displayName: "XResolution: ")
        self.getValue(dictionary: tiffDictionary, keyName: "Software", displayName: "Software: ")
      } else {
        print("TIF Not Found")
      }
      
      if let exif = fullImage.properties["{Exif}"], let exifDictionary = exif as? [String: Any?] {
        self.getValue(dictionary: exifDictionary, keyName: "BodySerialNumber", displayName: "Body SN: ")
         self.getValue(dictionary: exifDictionary, keyName: "LensSerialNumber", displayName: "Lens SN: ")
         self.getValue(dictionary: exifDictionary, keyName: "LensModel", displayName: "Lens: ")
         self.getValue(dictionary: exifDictionary, keyName: "FocalLength", displayName: "Focal Length: ")
         self.getValue(dictionary: exifDictionary, keyName: "FNumber", displayName: "F")
         self.getValue(dictionary: exifDictionary, keyName: "ShutterSpeedValue", displayName: "Shutter: ")
      } else {
        print("EXIF Not Found")
      }
 
      completed(.success(viewModel))
      
    }
  }
  
  @discardableResult
  private func getValue(dictionary: [String: Any?], keyName: String, displayName: String) -> String {
    if let optionalValue = dictionary[keyName], let value = optionalValue {
      print("\(displayName) \(value)")
      return String(describing: value)
    }
    return ""
  }

}
