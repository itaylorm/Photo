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
