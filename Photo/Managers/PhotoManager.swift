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

  let itemCountPerPage = 1000

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
    requestOptions.resizeMode = .exact
    
    let fetchOptions = PHFetchOptions()
    fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
    
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
        
//        let ratio = CGFloat(asset.pixelWidth) / CGFloat(asset.pixelHeight)
//        var width: CGFloat = 0
//        var height: CGFloat = 0
//        if asset.pixelHeight > asset.pixelWidth {
//          width = UIScreen.main.bounds.width * ratio
//          height = UIScreen.main.bounds.width
//        }
//        let size = CGSize(width: width, height: height)
        var size = CGSize(width: CGFloat(asset.pixelWidth) * 0.01, height: CGFloat(asset.pixelHeight) * 0.1)
        
//        var minRatio: CGFloat = 1
//        if CGFloat(asset.pixelWidth) > UIScreen.main.bounds.width || CGFloat(asset.pixelHeight) > UIScreen.main.bounds.height {
//          minRatio = min(UIScreen.main.bounds.width/(CGFloat(asset.pixelWidth)), (UIScreen.main.bounds.height/CGFloat(asset.pixelHeight)))
//        }
//        let size = CGSize(width: CGFloat(asset.pixelWidth) * minRatio, height: CGFloat(asset.pixelHeight) * minRatio)
        imgManager.requestImage(for: asset,
        targetSize: size,
        contentMode: .aspectFit, options: requestOptions) { (image, _) in
          if let image = image {
            images.append(PhotoViewModel(asset: asset, thumbNail: image))
          } else {
            print("Failed to retrieve image")
          }
        }
      }
    } else { print("Returned no records") }
    return images
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
