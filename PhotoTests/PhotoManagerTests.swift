//
//  PhotoManagerTests.swift
//  PhotoTests
//
//  Created by Taylor Maxwell on 2/10/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import XCTest
import Photos
@testable import Photo

class PhotoManagerTests: XCTestCase {

  let assetManager = AssetManagerMock()

  func testPhotoManagerGetPhotosSuccess() {
    let expectation = self.expectation(description: "Returned Assets")
    
    let photoManager = PhotoManager.shared
    assetManager.reset()
    photoManager.configure(assetManager: assetManager)
    
    var returnedAssets: [PhotoViewModel]?
    var returnedError: IMError?
    
    photoManager.getPhotos(page: 1) { result in
      
      switch result {
      case .success(let photoViewModels):
        returnedAssets = photoViewModels
      case .failure(let error):
        returnedError = error
      }
      expectation.fulfill()
    }
    
    waitForExpectations(timeout: 1, handler: nil)
    XCTAssertNil(returnedError, "Get Photos returned an error: \(String(describing: returnedError?.rawValue))")
    XCTAssertNotNil(returnedAssets)
    XCTAssertEqual(returnedAssets?.count, 3)
  }

  func testPhotoManagerGetPhotosFailure() {
    let expectation = self.expectation(description: "Returned Assets")
    
    let photoManager = PhotoManager.shared
    assetManager.reset()
    assetManager.authorizationStatus = PHAuthorizationStatus.denied
    photoManager.configure(assetManager: assetManager)
    
    var returnedAssets: [PhotoViewModel]?
    var returnedError: IMError?
    
    photoManager.getPhotos(page: 1) { result in
      
      switch result {
      case .success(let photoViewModels):
        returnedAssets = photoViewModels
      case .failure(let error):
        returnedError = error
      }
      expectation.fulfill()
    }
    
    waitForExpectations(timeout: 1, handler: nil)
    XCTAssertNil(returnedAssets, "Get Photos returned assets when access should be denied")
    XCTAssertEqual(returnedError, IMError.denied, "Get Photos did not return denied but returned: \(String(describing: returnedError?.rawValue))")
  }
}
