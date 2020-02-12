//
//  PhotoManagerGetSizeTests.swift
//  PhotoTests
//
//  Created by Taylor Maxwell on 2/12/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import Foundation
import XCTest
@testable import Photo

class PhotoManagerGetSizeTests: XCTestCase {

  enum ScreenSizes {
    static let iPhone11ProMaxandXsMaxPortrait = CGSize(width: 414, height: 896)
    static let iPhone11ProMaxandXsMaxLandscape = CGSize(width: 896, height: 414)
    static let iPhone11andXrPortrait = CGSize(width: 414, height: 896)
    static let iPhone11andXrLandscape = CGSize(width: 896, height: 414)
    static let iPhone11ProandXsandXPortrait = CGSize(width: 375, height: 812)
    static let iPhone11ProandXsandXLandscape = CGSize(width: 812, height: 375)
    static let iPhone8PlusPortrait = CGSize(width: 414, height: 736)
    static let iPhone8PlusLandscape = CGSize(width: 736, height: 414)
    static let iPhone8Portrait = CGSize(width: 375, height: 667)
    static let iPhone8Landscape = CGSize(width: 667, height: 375)
    static let iPhoneSEPortrait = CGSize(width: 320, height: 568)
    static let iPhoneSELandscape = CGSize(width: 568, height: 320)
  }

  enum ScreenScale {
    static let iPhone11ProMaxandXsMax: CGFloat = 3
      static let iPhone11andXr: CGFloat = 2
      static let iPhone11ProandXsandX: CGFloat = 3
      static let iPhone8Plus: CGFloat = 3
      static let iPhone8: CGFloat = 2
      static let iPhoneSE: CGFloat = 2
  }
  
  func test8PlusPortrait() {

    let imageSize = CGSize(width: 800, height: 628)
    let screenSize = CGRect(x: 0, y: 0,
                            width: ScreenSizes.iPhone8PlusPortrait.width,
                            height: ScreenSizes.iPhone8PlusPortrait.height - 300)
    let newSize = PhotoManager.shared.getPortraitSize(assetSize: imageSize, available: screenSize)
    XCTAssertEqual(round(newSize.width), 414)
    XCTAssertEqual(round(newSize.height), 325)
  }

}
