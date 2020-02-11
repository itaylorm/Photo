//
//  PhotoManagerGetPhotoInformationTests.swift
//  PhotoTests
//
//  Created by Taylor Maxwell on 2/11/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import XCTest
import Photos
@testable import Photo

class PhotoManagerGetPhotoInformationTests: XCTestCase {
  
  let assetManager = AssetManagerMock()
  
  func testPhotoManagerGetPhotoInformationSuccess() {
    let expectation = self.expectation(description: "Returned Photo Information")
    
    let photoManager = PhotoManager.shared
    assetManager.reset()
    photoManager.configure(assetManager: assetManager)
    
    let asset = PHAssetMock(pixelWidth: 3000, pixelHeight: 2000, creationDate: Date(), isFavorite: true)
    let photoViewModel = PhotoViewModel(asset: asset)
    var returnedVM: PhotoViewModel?
    var returnedError: IMError?
    
    photoManager.getPhotoInformation(viewModel: photoViewModel) { result in
      switch result {
      case .success(let photoViewModel):
        returnedVM = photoViewModel
      case .failure(let error):
        returnedError = error
      }
      expectation.fulfill()
    }
    
    waitForExpectations(timeout: 1, handler: nil)
    XCTAssertNil(returnedError, "Get Photo Information returned an unexpected error: \(String(describing: returnedError?.rawValue))")
    XCTAssertNotNil(returnedVM)
    
    let baseMessage = "Get Photo Information failed to return"
    let baseUnexpectedMessage = "Get Photo Information unexpectedly returned"
    if let returnedVM = returnedVM {
      XCTAssertEqual(returnedVM.profileName, CIImageMock.dictionary["ProfileName"] as? String, "\(baseMessage) profile name")
      XCTAssertEqual(returnedVM.colorModel, CIImageMock.dictionary["ColorModel"] as? String, "\(baseMessage) color model")
      
      XCTAssertEqual(returnedVM.make, CIImageMock.iphoneTiffDictionary["Make"] as? String, "\(baseMessage) make")
      XCTAssertEqual(returnedVM.model, CIImageMock.iphoneTiffDictionary["Model"] as? String, "\(baseMessage) model")
      XCTAssertEqual(returnedVM.software, CIImageMock.iphoneTiffDictionary["Software"] as? String, "\(baseMessage) software")
      
      let resolutionY = CIImageMock.iphoneTiffDictionary["YResolution"] as? Int
      XCTAssertEqual(returnedVM.resolutionY, String(resolutionY ?? 0), "\(baseMessage) resolution Y")
      
      let resolutionX = CIImageMock.iphoneTiffDictionary["XResolution"] as? Int
      XCTAssertEqual(returnedVM.resolutionX, String(resolutionX ?? 0), "\(baseMessage) resolution X")
      
      XCTAssertEqual(returnedVM.bodySerialNumber, "", "\(baseUnexpectedMessage) body serial number: \(returnedVM.bodySerialNumber ?? "")")
      XCTAssertEqual(returnedVM.lensSerialNumber, "", "\(baseUnexpectedMessage) lens serial number: \(returnedVM.lensSerialNumber ?? "")")
      XCTAssertEqual(returnedVM.lens, CIImageMock.iphoneExifDictionary["LensModel"] as? String, "\(baseMessage) make")
      XCTAssertEqual(returnedVM.focalLength, CIImageMock.iphoneExifDictionary["FocalLength"] as? String, "\(baseMessage) focal length")
      
      let focalLength35mm = CIImageMock.iphoneExifDictionary["FocalLenIn35mmFilm"] as? Int
      XCTAssertEqual(returnedVM.focalLength35mm, String(focalLength35mm ?? 0), "\(baseMessage) focal length 35mm")
      
      XCTAssertEqual(returnedVM.shutterSpeed, CIImageMock.iphoneExifDictionary["ShutterSpeedValue"] as? String, "\(baseMessage) make")
      
      if let expectedISOValue = CIImageMock.iphoneExifDictionary["ISOSpeedRatings"], let expectedISOArray = expectedISOValue as? [Int] {
        let expectedISO = expectedISOArray.map { String($0) }.joined(separator: ",")
        XCTAssertEqual(returnedVM.iso, expectedISO, "\(baseMessage) iso")
      }
      
      if let expectedKeywordValue = CIImageMock.iptcDictionary["Keywords"], let expectedKeywordArray = expectedKeywordValue as? [String] {
        let expectedKeywords = expectedKeywordArray.map { String($0) }.joined(separator: ",")
        XCTAssertEqual(returnedVM.keyWords, expectedKeywords, "\(baseMessage) keywords")
      }
      
    }
    
  }

  func testPhotoManagerGetPhotoInformationSlrSuccess() {
    let expectation = self.expectation(description: "Returned Slr Photo Information")
    
    let photoManager = PhotoManager.shared
    assetManager.reset()
    assetManager.imageInformationStatus = .slrSuccess
    photoManager.configure(assetManager: assetManager)
    
    let asset = PHAssetMock(pixelWidth: 3000, pixelHeight: 2000, creationDate: Date(), isFavorite: true)
    let photoViewModel = PhotoViewModel(asset: asset)
    var returnedVM: PhotoViewModel?
    var returnedError: IMError?
    
    photoManager.getPhotoInformation(viewModel: photoViewModel) { result in
      switch result {
      case .success(let photoViewModel):
        returnedVM = photoViewModel
      case .failure(let error):
        returnedError = error
      }
      expectation.fulfill()
    }
    
    waitForExpectations(timeout: 1, handler: nil)
    XCTAssertNil(returnedError, "Get Photo Information returned an unexpected error: \(String(describing: returnedError?.rawValue))")
    XCTAssertNotNil(returnedVM)
    
    let baseMessage = "Get Photo Information failed to return"
    let baseUnexpectedMessage = "Get Photo Information unexpectedly returned"
    if let returnedVM = returnedVM {
      XCTAssertEqual(returnedVM.profileName, CIImageMock.dictionary["ProfileName"] as? String, "\(baseMessage) profile name")
      XCTAssertEqual(returnedVM.colorModel, CIImageMock.dictionary["ColorModel"] as? String, "\(baseMessage) color model")
      
      XCTAssertEqual(returnedVM.make, CIImageMock.slrTiffDictionary["Make"] as? String, "\(baseMessage) make")
      XCTAssertEqual(returnedVM.model, CIImageMock.slrTiffDictionary["Model"] as? String, "\(baseMessage) model")
      XCTAssertEqual(returnedVM.software, CIImageMock.slrTiffDictionary["Software"] as? String, "\(baseMessage) software")
      
      let resolutionY = CIImageMock.slrTiffDictionary["YResolution"] as? Int
      XCTAssertEqual(returnedVM.resolutionY, String(resolutionY ?? 0), "\(baseMessage) resolution Y")
      
      let resolutionX = CIImageMock.slrTiffDictionary["XResolution"] as? Int
      XCTAssertEqual(returnedVM.resolutionX, String(resolutionX ?? 0), "\(baseMessage) resolution X")
      
      XCTAssertEqual(returnedVM.bodySerialNumber, CIImageMock.slrExifDictionary["BodySerialNumber"] as? String,
                     "\(baseMessage) body serial number: \(returnedVM.bodySerialNumber ?? "")")
      XCTAssertEqual(returnedVM.lensSerialNumber, CIImageMock.slrExifDictionary["LensSerialNumber"] as? String,
                     "\(baseUnexpectedMessage) lens serial number: \(returnedVM.lensSerialNumber ?? "")")
      XCTAssertEqual(returnedVM.lens, CIImageMock.slrExifDictionary["LensModel"] as? String, "\(baseMessage) make")
      XCTAssertEqual(returnedVM.focalLength, CIImageMock.slrExifDictionary["FocalLength"] as? String, "\(baseMessage) focal length")
      
      let focalLength35mm = CIImageMock.slrExifDictionary["FocalLenIn35mmFilm"] as? Int
      XCTAssertEqual(returnedVM.focalLength35mm, String(focalLength35mm ?? 0), "\(baseMessage) focal length 35mm")
      XCTAssertEqual(returnedVM.shutterSpeed, CIImageMock.slrExifDictionary["ShutterSpeedValue"] as? String, "\(baseMessage) make")
      
      if let expectedISOValue = CIImageMock.slrExifDictionary["ISOSpeedRatings"], let expectedISOArray = expectedISOValue as? [Int] {
        let expectedISO = expectedISOArray.map { String($0) }.joined(separator: ",")
        XCTAssertEqual(returnedVM.iso, expectedISO, "\(baseMessage) iso")
      }
      
      if let expectedKeywordValue = CIImageMock.iptcDictionary["Keywords"], let expectedKeywordArray = expectedKeywordValue as? [String] {
        let expectedKeywords = expectedKeywordArray.map { String($0) }.joined(separator: ",")
        XCTAssertEqual(returnedVM.keyWords, expectedKeywords, "\(baseMessage) keywords")
      }
      
    }
    
  }
  
  func testPhotoManagerGetPhotoInformationWithoutExif() {
    let expectation = self.expectation(description: "Returned Photo Information without Exif")
    
    let photoManager = PhotoManager.shared
    assetManager.reset()
    assetManager.imageInformationStatus = .missingExif
    
    photoManager.configure(assetManager: assetManager)
    
    let asset = PHAssetMock(pixelWidth: 3000, pixelHeight: 2000, creationDate: Date(), isFavorite: true)
    let photoViewModel = PhotoViewModel(asset: asset)
    var returnedVM: PhotoViewModel?
    var returnedError: IMError?
    
    photoManager.getPhotoInformation(viewModel: photoViewModel) { result in
      switch result {
      case .success(let photoViewModel):
        returnedVM = photoViewModel
      case .failure(let error):
        returnedError = error
      }
      expectation.fulfill()
    }
    
    waitForExpectations(timeout: 1, handler: nil)
    XCTAssertNil(returnedError, "Get Photo Information returned an unexpected error: \(String(describing: returnedError?.rawValue))")
    XCTAssertNotNil(returnedVM)
    
    let baseMessage = "Get Photo Information failed to return"
    let baseUnexpectedMessage = "Get Photo Information unexpectedly returned"
    if let returnedVM = returnedVM {
      XCTAssertEqual(returnedVM.profileName, CIImageMock.dictionary["ProfileName"] as? String, "\(baseMessage) profile name")
      XCTAssertEqual(returnedVM.colorModel, CIImageMock.dictionary["ColorModel"] as? String, "\(baseMessage) color model")
      
      XCTAssertEqual(returnedVM.make, CIImageMock.iphoneTiffDictionary["Make"] as? String, "\(baseMessage) make")
      XCTAssertEqual(returnedVM.model, CIImageMock.iphoneTiffDictionary["Model"] as? String, "\(baseMessage) model")
      XCTAssertEqual(returnedVM.software, CIImageMock.iphoneTiffDictionary["Software"] as? String, "\(baseMessage) software")
      
      let resolutionY = CIImageMock.iphoneTiffDictionary["YResolution"] as? Int
      XCTAssertEqual(returnedVM.resolutionY, String(resolutionY ?? 0), "\(baseMessage) resolution Y")
      
      let resolutionX = CIImageMock.iphoneTiffDictionary["XResolution"] as? Int
      XCTAssertEqual(returnedVM.resolutionX, String(resolutionX ?? 0), "\(baseMessage) resolution X")
      
      XCTAssertNil(returnedVM.bodySerialNumber, "\(baseUnexpectedMessage) body serial number: \(returnedVM.bodySerialNumber ?? "")")
      XCTAssertNil(returnedVM.lensSerialNumber, "\(baseUnexpectedMessage) lens serial number: \(returnedVM.lensSerialNumber ?? "")")
      XCTAssertNil(returnedVM.lens, "\(baseUnexpectedMessage) make")
      XCTAssertNil(returnedVM.focalLength, "\(baseUnexpectedMessage) focal length")
      XCTAssertNil(returnedVM.focalLength35mm, "\(baseUnexpectedMessage) focal length 35mm")
      XCTAssertNil(returnedVM.shutterSpeed, "\(baseUnexpectedMessage) make")
      XCTAssertNil(returnedVM.iso, "\(baseUnexpectedMessage) iso")
      
      if let expectedKeywordValue = CIImageMock.iptcDictionary["Keywords"], let expectedKeywordArray = expectedKeywordValue as? [String] {
        let expectedKeywords = expectedKeywordArray.map { String($0) }.joined(separator: ",")
        XCTAssertEqual(returnedVM.keyWords, expectedKeywords, "\(baseMessage) keywords")
      }
      
    }
    
  }
  
  func testPhotoManagerGetPhotoInformationWithoutTiff() {
    let expectation = self.expectation(description: "Returned Photo Information without Tiff")
    
    let photoManager = PhotoManager.shared
    assetManager.reset()
    assetManager.imageInformationStatus = .missingTiff
    photoManager.configure(assetManager: assetManager)
    
    let asset = PHAssetMock(pixelWidth: 3000, pixelHeight: 2000, creationDate: Date(), isFavorite: true)
    let photoViewModel = PhotoViewModel(asset: asset)
    var returnedVM: PhotoViewModel?
    var returnedError: IMError?
    
    photoManager.getPhotoInformation(viewModel: photoViewModel) { result in
      switch result {
      case .success(let photoViewModel):
        returnedVM = photoViewModel
      case .failure(let error):
        returnedError = error
      }
      expectation.fulfill()
    }
    
    waitForExpectations(timeout: 1, handler: nil)
    XCTAssertNil(returnedError, "Get Photo Information returned an unexpected error: \(String(describing: returnedError?.rawValue))")
    XCTAssertNotNil(returnedVM)
    
    let baseMessage = "Get Photo Information failed to return"
    let baseUnexpectedMessage = "Get Photo Information unexpectedly returned"
    if let returnedVM = returnedVM {
      XCTAssertEqual(returnedVM.profileName, CIImageMock.dictionary["ProfileName"] as? String, "\(baseMessage) profile name")
      XCTAssertEqual(returnedVM.colorModel, CIImageMock.dictionary["ColorModel"] as? String, "\(baseMessage) color model")
      
      XCTAssertNil(returnedVM.make, "\(baseUnexpectedMessage) make")
      XCTAssertNil(returnedVM.model, "\(baseUnexpectedMessage) model")
      XCTAssertNil(returnedVM.software, "\(baseUnexpectedMessage) software")
      XCTAssertNil(returnedVM.resolutionY, "\(baseUnexpectedMessage) resolution Y")
      XCTAssertNil(returnedVM.resolutionX, "\(baseUnexpectedMessage) resolution X")
      
      XCTAssertEqual(returnedVM.bodySerialNumber, "", "\(baseUnexpectedMessage) body serial number: \(returnedVM.bodySerialNumber ?? "")")
      XCTAssertEqual(returnedVM.lensSerialNumber, "", "\(baseUnexpectedMessage) lens serial number: \(returnedVM.lensSerialNumber ?? "")")
      XCTAssertEqual(returnedVM.lens, CIImageMock.iphoneExifDictionary["LensModel"] as? String, "\(baseMessage) make")
      XCTAssertEqual(returnedVM.focalLength, CIImageMock.iphoneExifDictionary["FocalLength"] as? String, "\(baseMessage) focal length")
      
      let focalLength35mm = CIImageMock.iphoneExifDictionary["FocalLenIn35mmFilm"] as? Int
      XCTAssertEqual(returnedVM.focalLength35mm, String(focalLength35mm ?? 0), "\(baseMessage) focal length 35mm")
      
      XCTAssertEqual(returnedVM.shutterSpeed, CIImageMock.iphoneExifDictionary["ShutterSpeedValue"] as? String, "\(baseMessage) make")
      
      if let expectedISOValue = CIImageMock.iphoneExifDictionary["ISOSpeedRatings"], let expectedISOArray = expectedISOValue as? [Int] {
        let expectedISO = expectedISOArray.map { String($0) }.joined(separator: ",")
        XCTAssertEqual(returnedVM.iso, expectedISO, "\(baseMessage) iso")
      }
      
      if let expectedKeywordValue = CIImageMock.iptcDictionary["Keywords"], let expectedKeywordArray = expectedKeywordValue as? [String] {
        let expectedKeywords = expectedKeywordArray.map { String($0) }.joined(separator: ",")
        XCTAssertEqual(returnedVM.keyWords, expectedKeywords, "\(baseMessage) keywords")
      }
      
    }
  }
  
  func testPhotoManagerGetPhotoInformationWithoutIptc() {
    let expectation = self.expectation(description: "Returned Photo Information without Iptc")
    
    let photoManager = PhotoManager.shared
    assetManager.reset()
    assetManager.imageInformationStatus = .missingIptc
    photoManager.configure(assetManager: assetManager)
    
    let asset = PHAssetMock(pixelWidth: 3000, pixelHeight: 2000, creationDate: Date(), isFavorite: true)
    let photoViewModel = PhotoViewModel(asset: asset)
    var returnedVM: PhotoViewModel?
    var returnedError: IMError?
    
    photoManager.getPhotoInformation(viewModel: photoViewModel) { result in
      switch result {
      case .success(let photoViewModel):
        returnedVM = photoViewModel
      case .failure(let error):
        returnedError = error
      }
      expectation.fulfill()
    }
    
    waitForExpectations(timeout: 1, handler: nil)
    XCTAssertNil(returnedError, "Get Photo Information returned an unexpected error: \(String(describing: returnedError?.rawValue))")
    XCTAssertNotNil(returnedVM)
    
    let baseMessage = "Get Photo Information failed to return"
    let baseUnexpectedMessage = "Get Photo Information unexpectedly returned"
    if let returnedVM = returnedVM {
      XCTAssertEqual(returnedVM.profileName, CIImageMock.dictionary["ProfileName"] as? String, "\(baseMessage) profile name")
      XCTAssertEqual(returnedVM.colorModel, CIImageMock.dictionary["ColorModel"] as? String, "\(baseMessage) color model")
      
      XCTAssertEqual(returnedVM.make, CIImageMock.iphoneTiffDictionary["Make"] as? String, "\(baseMessage) make")
      XCTAssertEqual(returnedVM.model, CIImageMock.iphoneTiffDictionary["Model"] as? String, "\(baseMessage) model")
      XCTAssertEqual(returnedVM.software, CIImageMock.iphoneTiffDictionary["Software"] as? String, "\(baseMessage) software")
      
      let resolutionY = CIImageMock.iphoneTiffDictionary["YResolution"] as? Int
      XCTAssertEqual(returnedVM.resolutionY, String(resolutionY ?? 0), "\(baseMessage) resolution Y")
      
      let resolutionX = CIImageMock.iphoneTiffDictionary["XResolution"] as? Int
      XCTAssertEqual(returnedVM.resolutionX, String(resolutionX ?? 0), "\(baseMessage) resolution X")
      
      XCTAssertEqual(returnedVM.bodySerialNumber, "", "\(baseUnexpectedMessage) body serial number: \(returnedVM.bodySerialNumber ?? "")")
      XCTAssertEqual(returnedVM.lensSerialNumber, "", "\(baseUnexpectedMessage) lens serial number: \(returnedVM.lensSerialNumber ?? "")")
      XCTAssertEqual(returnedVM.lens, CIImageMock.iphoneExifDictionary["LensModel"] as? String, "\(baseMessage) make")
      XCTAssertEqual(returnedVM.focalLength, CIImageMock.iphoneExifDictionary["FocalLength"] as? String, "\(baseMessage) focal length")
      
      let focalLength35mm = CIImageMock.iphoneExifDictionary["FocalLenIn35mmFilm"] as? Int
      XCTAssertEqual(returnedVM.focalLength35mm, String(focalLength35mm ?? 0), "\(baseMessage) focal length 35mm")
      
      XCTAssertEqual(returnedVM.shutterSpeed, CIImageMock.iphoneExifDictionary["ShutterSpeedValue"] as? String, "\(baseMessage) make")
      
      if let expectedISOValue = CIImageMock.iphoneExifDictionary["ISOSpeedRatings"], let expectedISOArray = expectedISOValue as? [Int] {
        let expectedISO = expectedISOArray.map { String($0) }.joined(separator: ",")
        XCTAssertEqual(returnedVM.iso, expectedISO, "\(baseMessage) iso")
      }
      
      XCTAssertNil(returnedVM.keyWords, "\(baseUnexpectedMessage) keywords")
      
    }
    
  }
}
