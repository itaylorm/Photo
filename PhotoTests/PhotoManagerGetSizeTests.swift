//
//  PhotoManagerGetSizeTests.swift
//  PhotoTests
//
//  Created by Taylor Maxwell on 2/12/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import UIKit
import XCTest
@testable import Photo

class PhotoManagerGetSizeTests: XCTestCase {
  
  let smallPortraitSize = CGSize(width: 50, height: 75)
  let mediumPortraitSize = CGSize(width: 756, height: 1008)
  let largePortraitSize = CGSize(width: 3024, height: 4032)
  let smallLandscapeSize = CGSize(width: 75, height: 50)
  let mediumLandscapeSize = CGSize(width: 1008, height: 756)
  let largeLandscapeSize = CGSize(width: 4032, height: 3024)
  
  func test8PlusPortraitSmallSizedPhoto() {
    let screenSize = CGRect(x: 0, y: 0,
                            width: PhoneSizes.iPhone8PlusPortrait.width,
                            height: PhoneSizes.iPhone8PlusPortrait.height)
    let newSize = PhotoManager.shared.getPhotoSizeToRequest(assetSize: smallPortraitSize, available: screenSize)
    XCTAssertEqual(round(newSize.width), 414)
    XCTAssertEqual(round(newSize.height), 621)
  }
  
  func test8PlusPortraitMediumSizedPhoto() {
    let screenSize = CGRect(x: 0, y: 0,
                            width: PhoneSizes.iPhone8PlusPortrait.width,
                            height: PhoneSizes.iPhone8PlusPortrait.height)
    let newSize = PhotoManager.shared.getPhotoSizeToRequest(assetSize: mediumPortraitSize, available: screenSize)
    XCTAssertEqual(round(newSize.width), 414)
    XCTAssertEqual(round(newSize.height), 552)
  }
  
  func test8PlusPortraitLargeSizedPhoto() {
    let screenSize = CGRect(x: 0, y: 0,
                            width: PhoneSizes.iPhone8PlusPortrait.width,
                            height: PhoneSizes.iPhone8PlusPortrait.height)
    let newSize = PhotoManager.shared.getPhotoSizeToRequest(assetSize: largePortraitSize, available: screenSize)
    XCTAssertEqual(round(newSize.width), 414)
    XCTAssertEqual(round(newSize.height), 552)
  }
  
  func test8PlusPortraitSmallSizedWidePhoto() {
    let screenSize = CGRect(x: 0, y: 0,
                            width: PhoneSizes.iPhone8PlusPortrait.width,
                            height: PhoneSizes.iPhone8PlusPortrait.height)
    let newSize = PhotoManager.shared.getPhotoSizeToRequest(assetSize: smallLandscapeSize, available: screenSize)
    XCTAssertEqual(round(newSize.width), 414)
    XCTAssertEqual(round(newSize.height), 276)
  }

  func test8PlusPortraitMediumSizedWidePhoto() {
    let screenSize = CGRect(x: 0, y: 0,
                            width: PhoneSizes.iPhone8PlusPortrait.width,
                            height: PhoneSizes.iPhone8PlusPortrait.height)
    let newSize = PhotoManager.shared.getPhotoSizeToRequest(assetSize: mediumLandscapeSize, available: screenSize)
    XCTAssertEqual(round(newSize.width), 414)
    XCTAssertEqual(round(newSize.height), 311)
  }
  
  func test8PlusPortraitLargeSizedWidePhoto() {
    let screenSize = CGRect(x: 0, y: 0,
                            width: PhoneSizes.iPhone8PlusPortrait.width,
                            height: PhoneSizes.iPhone8PlusPortrait.height)
    let newSize = PhotoManager.shared.getPhotoSizeToRequest(assetSize: largeLandscapeSize, available: screenSize)
    XCTAssertEqual(round(newSize.width), 414)
    XCTAssertEqual(round(newSize.height), 311)
  }
  
   func test8PlusLandscapeSmallSizedPhoto() {
     let screenSize = CGRect(x: 0, y: 0,
                             width: PhoneSizes.iPhone8PlusLandscape.width,
                             height: PhoneSizes.iPhone8PlusLandscape.height)
     let newSize = PhotoManager.shared.getPhotoSizeToRequest(assetSize: smallPortraitSize, available: screenSize)
     XCTAssertEqual(round(newSize.width), 276)
     XCTAssertEqual(round(newSize.height), 414)
   }

   func test8PlusLandscapeMediumSizedPhoto() {
     let screenSize = CGRect(x: 0, y: 0,
                             width: PhoneSizes.iPhone8PlusLandscape.width,
                             height: PhoneSizes.iPhone8PlusLandscape.height)
     let newSize = PhotoManager.shared.getPhotoSizeToRequest(assetSize: mediumPortraitSize, available: screenSize)
     XCTAssertEqual(round(newSize.width), 311)
     XCTAssertEqual(round(newSize.height), 414)
   }
   
   func test8PlusLandscapeLargeSizedPhoto() {
     let screenSize = CGRect(x: 0, y: 0,
                             width: PhoneSizes.iPhone8PlusLandscape.width,
                             height: PhoneSizes.iPhone8PlusLandscape.height)
     let newSize = PhotoManager.shared.getPhotoSizeToRequest(assetSize: largePortraitSize, available: screenSize)
     XCTAssertEqual(round(newSize.width), 311)
     XCTAssertEqual(round(newSize.height), 414)
   }
  
  func test8PlusLandscapeSmallSizedWidePhoto() {
    let screenSize = CGRect(x: 0, y: 0,
                            width: PhoneSizes.iPhone8PlusLandscape.width,
                            height: PhoneSizes.iPhone8PlusLandscape.height)
    let newSize = PhotoManager.shared.getPhotoSizeToRequest(assetSize: smallLandscapeSize, available: screenSize)
    XCTAssertEqual(round(newSize.width), 621)
    XCTAssertEqual(round(newSize.height), 414)
  }

  func test8PlusLandscapeMediumSizedWidePhoto() {
    let screenSize = CGRect(x: 0, y: 0,
                            width: PhoneSizes.iPhone8PlusLandscape.width,
                            height: PhoneSizes.iPhone8PlusLandscape.height)
    let newSize = PhotoManager.shared.getPhotoSizeToRequest(assetSize: mediumLandscapeSize, available: screenSize)
    XCTAssertEqual(round(newSize.width), 552)
    XCTAssertEqual(round(newSize.height), 414)
  }
  
  func test8PlusLandscapeLargeSizedWidePhoto() {
    let screenSize = CGRect(x: 0, y: 0,
                            width: PhoneSizes.iPhone8PlusLandscape.width,
                            height: PhoneSizes.iPhone8PlusLandscape.height)
    let newSize = PhotoManager.shared.getPhotoSizeToRequest(assetSize: largeLandscapeSize, available: screenSize)
    XCTAssertEqual(round(newSize.width), 552)
    XCTAssertEqual(round(newSize.height), 414)
  }
}
