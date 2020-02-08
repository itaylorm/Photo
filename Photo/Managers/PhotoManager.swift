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
  
  func getPhotoInformation(viewModel: PhotoViewModel, completed: @escaping(Result<PhotoViewModel, IMError>) -> Void) {
    
    let options = PHContentEditingInputRequestOptions()
    options.isNetworkAccessAllowed = true
    viewModel.asset.requestContentEditingInput(with: options) { (contentEditingInput: PHContentEditingInput?, _) in
      
      guard let url = contentEditingInput?.fullSizeImageURL, let fullImage = CIImage(contentsOf: url) else {
        completed(.failure(.unableToComplete))
        return
      }
      //print(fullImage.properties)
      guard let profileName = fullImage.properties["ProfileName"] else {
        completed(.failure(.dataNotFound))
        return
      }
      print(profileName)
      
      // Does not work yet
      if let iso = fullImage.properties["ISOSpeedRatings"] {
        print(iso)
      }
      
      guard let iptc = fullImage.properties["{IPTC}"], let iptcDictionary = iptc as? Dictionary<String, Any?> else {
        completed(.failure(.dataNotFound))
        return
      }
      //print(iptcDictionary)
      
      guard let tif = fullImage.properties["{TIFF}"], let tiffDictionary = tif as? Dictionary<String, Any?> else {
        completed(.failure(.dataNotFound))
        return
      }
      
      self.getValue(dictionary: tiffDictionary, keyName: "Make", displayName: "Make: ")
      self.getValue(dictionary: tiffDictionary, keyName: "Model", displayName: "Model: ")
      self.getValue(dictionary: tiffDictionary, keyName: "YResolution", displayName: "YResolution: ")
      self.getValue(dictionary: tiffDictionary, keyName: "XResolution", displayName: "XResolution: ")
      self.getValue(dictionary: tiffDictionary, keyName: "Software", displayName: "Software: ")
      
      guard let exif = fullImage.properties["{Exif}"], let exifDictionary = exif as? Dictionary<String, Any?> else {
        completed(.failure(.dataNotFound))
        return
      }
      self.getValue(dictionary: exifDictionary, keyName: "BodySerialNumber", displayName: "Body SN: ")
      self.getValue(dictionary: exifDictionary, keyName: "LensSerialNumber", displayName: "Lens SN: ")
      self.getValue(dictionary: exifDictionary, keyName: "LensModel", displayName: "Lens: ")
      self.getValue(dictionary: exifDictionary, keyName: "FocalLength", displayName: "Focal Length: ")
      self.getValue(dictionary: exifDictionary, keyName: "FNumber", displayName: "F")
      self.getValue(dictionary: exifDictionary, keyName: "ShutterSpeedValue", displayName: "Shutter: ")
      completed(.success(viewModel))
      
    }
  }
  
  @discardableResult
  private func getValue(dictionary: Dictionary<String, Any?>, keyName: String, displayName: String) -> String {
    if let optionalValue = dictionary[keyName], let value = optionalValue {
      print("\(displayName) \(value)")
      return String(describing: value)
    }
    return ""
  }
  
  func setProperties(photoViewModel: PhotoViewModel) {
      let options = PHContentEditingInputRequestOptions()
      options.isNetworkAccessAllowed = true
      photoViewModel.asset.requestContentEditingInput(with: options) { (contentEditingInput: PHContentEditingInput?, _) in
          guard let url = contentEditingInput?.fullSizeImageURL else { return }
          guard let fullImage = CIImage(contentsOf: url) else { return }
          guard let exif = fullImage.properties["{Exif}"] else { return}

          guard let dictionary = exif as? Dictionary<String, Any?> else { return }
          guard let dateTimeString = dictionary["DateTimeOriginal"] as? String else { return }
          let date = Date.convertPhotoDateToDate(dateTimeString)
          print(date?.convertToMonthYearFormat() ?? "No Creation Date")
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
      
      //https://stackoverflow.com/questions/53098339/fetch-all-photos-from-library-based-on-creationdate-in-swift-faster-way
//        let startDate = Date()
//        let endDate = Date()
//        fetchOptions.predicate = NSPredicate(format: "creationDate > %@ AND creationDate < %@", startDate as NSDate, endDate as NSDate)
      let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
      if !fetchResult.isEmpty() {
          
          let totalPhotos = fetchResult.count
          let startIndex = (itemCountPerPage * (page - 1)) + (page == 1 ? 0 : 1)
          var endIndex = itemCountPerPage * page
          
          if startIndex > totalPhotos { return images }
          if endIndex > totalPhotos { endIndex = totalPhotos - 1 }
          
          for imageIndex in startIndex...endIndex {
              let asset = fetchResult.object(at: imageIndex) as PHAsset
               imgManager.requestImage(for: asset,
                                       targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight),
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
