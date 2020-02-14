//
//  PhotoManager.swift
//  Photo
//
//  Created by Taylor Maxwell on 2/6/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import UIKit
import Photos
import CoreLocation

enum PhotoType {
  case forList
  case forInfo
}

class PhotoManager {
  static let shared = PhotoManager()
  
  var assetManager: AssetManagerProtocol = AssetManager()
  
  let itemCountPerPage = 1000
  
  init() {}
  
  func configure(assetManager: AssetManagerProtocol) {
    self.assetManager = assetManager
  }
  
  func getPhoto(photoViewModel: PhotoViewModel, available: CGRect, photoType: PhotoType) -> UIImage? {
    var photo: UIImage?
    let asset = photoViewModel.asset
    let size = getPhotoSizeToRequest(assetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), available: available)
    let options = PHImageRequestOptions()
    options.isSynchronous = true
    options.resizeMode = .fast
    
    switch photoType {
    case .forList:
      options.deliveryMode = .fastFormat
    case .forInfo:
      options.deliveryMode = .highQualityFormat
    }
    
    assetManager.requestImage(for: asset,
                              targetSize: size,
                              contentMode: .default, options: options) { (image, _) in
                                if let image = image {
                                  photo = image
                                } else {
                                  print("Failed to retrieve image")
                                }
    }
    return photo
  }
  
  func resizePhoto(image: UIImage?, available: CGRect) -> UIImage? {
    guard let image = image else { return nil }
    
    var newImage: UIImage?
    let newSize = getPhotoSizeToRequest(assetSize: image.size, available: available)
    
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage
  }
  
  func getPhotos(page: Int, completed: @escaping(Result<[PhotoViewModel], IMError>) -> Void) {
    guard page > 0 else {
      completed(.failure(IMError.pageIndexCannotBeZeroOrNegative))
      return
    }
    
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
  
  func requestAccessToPhotos(authClosure: @escaping (PHAuthorizationStatus) -> Void) {
    assetManager.requestAuthorization { (authStatus: PHAuthorizationStatus) -> Void in
      authClosure(authStatus)
    }
  }
  
  func getPhotoInformation(viewModel: PhotoViewModel, completed: @escaping(Result<PhotoViewModel, IMError>) -> Void) {
    guard !viewModel.informationLoaded else { return }
    
    let options = PHContentEditingInputRequestOptions()
    options.isNetworkAccessAllowed = true
    assetManager.requestContentEditingInput(with: options, asset: viewModel.asset) { (contentEditingInput: PHContentEditingInput?, _) in
      guard let url = contentEditingInput?.fullSizeImageURL,
        let fullImage = self.assetManager.getCIImage(contentsOf: url) else {
          completed(.failure(.unableToComplete))
          return
      }
      
      viewModel.colorModel = self.getValue(image: fullImage, keyName: "ColorModel", displayName: "Color Model: ")
      viewModel.profileName = self.getValue(image: fullImage, keyName: "ProfileName", displayName: "Profile Name: ")
      self.getIptcInformation(fullImage: fullImage, viewModel: viewModel)
      self.getTifInformation(fullImage: fullImage, viewModel: viewModel)
      self.getExifInformation(fullImage: fullImage, viewModel: viewModel)
      
      viewModel.informationLoaded = true
      completed(.success(viewModel))
      
    }
  }
  
  func getPhotoSizeToRequest(assetSize: CGSize, available: CGRect) -> CGSize {
    var height: CGFloat
    var width: CGFloat
    
    let heightScale: CGFloat = available.height / assetSize.height
    let widthScale: CGFloat = available.width / assetSize.width
    if heightScale < widthScale {
      height = assetSize.height * heightScale
      width = assetSize.width * heightScale
    } else {
      height = assetSize.height * widthScale
      width = assetSize.width * widthScale
    }
    return CGSize(width: width, height: height)
  }
  
  private func getImagesFromPhotoLibrary(page: Int) -> [PhotoViewModel] {
    var images = [PhotoViewModel]()
    guard page > 0 else { return images }
    
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
    let fetchResult: PHFetchResult = assetManager.fetchAssets(with: .image, options: fetchOptions)
    if !fetchResult.isEmpty() {
      
      let totalPhotos = fetchResult.count
      let startIndex = (itemCountPerPage * (page - 1)) + (page == 1 ? 0 : 1)
      var endIndex = itemCountPerPage * page
      
      if startIndex > totalPhotos { return images }
      if endIndex > totalPhotos { endIndex = totalPhotos - 1 }
      
      for imageIndex in startIndex...endIndex {
        let asset = fetchResult.object(at: imageIndex) as PHAsset
        images.append(PhotoViewModel(asset: asset))
      }
    } else { print("Returned no records") }
    return images
  }
  
  private func getExifInformation(fullImage: CIImage, viewModel: PhotoViewModel) {
    if let exif = fullImage.properties["{Exif}"], let exifDictionary = exif as? [String: Any?] {
      viewModel.bodySerialNumber = self.getValue(dictionary: exifDictionary, keyName: "BodySerialNumber", displayName: "Body SN: ")
      viewModel.lensSerialNumber = self.getValue(dictionary: exifDictionary, keyName: "LensSerialNumber", displayName: "Lens SN: ")
      viewModel.lens = self.getValue(dictionary: exifDictionary, keyName: "LensModel", displayName: "Lens: ")
      viewModel.focalLength = self.getValue(dictionary: exifDictionary, keyName: "FocalLength", displayName: "Focal Length: ")
      viewModel.focalLength35mm = self.getValue(dictionary: exifDictionary, keyName: "FocalLenIn35mmFilm", displayName: "Focal Length In 35mm: ")
      viewModel.aperture = self.getValue(dictionary: exifDictionary, keyName: "FNumber", displayName: "F")
      viewModel.shutterSpeed = self.getValue(dictionary: exifDictionary, keyName: "ShutterSpeedValue", displayName: "Shutter: ")
      
      if let isoRaw = exifDictionary["ISOSpeedRatings"], let isoArray = isoRaw as? [Int] {
        viewModel.iso = isoArray.map { String($0) }.joined(separator: ",")
        //print("ISO: \(viewModel.iso!)")
      }
    } else {
      print("EXIF Not Found")
    }
  }
  
  private func getTifInformation(fullImage: CIImage, viewModel: PhotoViewModel) {
    if let tif = fullImage.properties["{TIFF}"], let tiffDictionary = tif as? [String: Any?] {
      viewModel.make = self.getValue(dictionary: tiffDictionary, keyName: "Make", displayName: "Make: ")
      viewModel.model = self.getValue(dictionary: tiffDictionary, keyName: "Model", displayName: "Model: ")
      viewModel.resolutionY = self.getValue(dictionary: tiffDictionary, keyName: "YResolution", displayName: "YResolution: ")
      viewModel.resolutionX = self.getValue(dictionary: tiffDictionary, keyName: "XResolution", displayName: "XResolution: ")
      viewModel.software = self.getValue(dictionary: tiffDictionary, keyName: "Software", displayName: "Software: ")
    } else {
      print("TIF Not Found")
    }
  }
  
  private func getIptcInformation(fullImage: CIImage, viewModel: PhotoViewModel) {
    if let iptc = fullImage.properties["{IPTC}"], let iptcDictionary = iptc as? [String: Any?] {
      viewModel.starRating = self.getValue(dictionary: iptcDictionary, keyName: "StarRating", displayName: "Rating: ")
      
      if let keywordRaw = iptcDictionary["Keywords"], let keywordArray = keywordRaw as? [String] {
        viewModel.keyWords = keywordArray.joined(separator: ",")
        //print("Keywords: \(viewModel.keyWords!)")
      }
    } else {
      print("IPTC Not Found")
    }
  }
  
  private func getValue(dictionary: [String: Any?], keyName: String, displayName: String) -> String {
    if let optionalValue = dictionary[keyName], let value = optionalValue {
      //print("\(displayName) \(value)")
      return String(describing: value)
    }
    return ""
  }
  
  private func getValue(image: CIImage, keyName: String, displayName: String) -> String {
    if let optionalValue = image.properties[keyName], let value = optionalValue as? String {
      //print("\(displayName) \(value)")
      return String(describing: value)
    }
    return ""
  }
}
