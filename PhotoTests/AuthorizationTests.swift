//
//  AuthorizationTests.swift
//  PhotoTests
//
//  Created by Taylor Maxwell on 2/10/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import XCTest
import Photos
@testable import Photo

class AuthorizationTests: XCTestCase {

    let assetManager = AssetManagerMock()

    func testAuthorizationSuccess() {
      let expectation = self.expectation(description: "User is authorized")
      
      var authorizationStatus: PHAuthorizationStatus?
      
      let photoManager = PhotoManager.shared
      assetManager.reset()
      photoManager.configure(assetManager: assetManager)
      
      photoManager.requestAccessToPhotos { status in
        authorizationStatus = status
        expectation.fulfill()
      }
      
      waitForExpectations(timeout: 1, handler: nil)
      XCTAssertEqual(authorizationStatus, PHAuthorizationStatus.authorized, "Request for access to user photos denied")
    }
    
    func testDeniedAuthorization() {
      let expectation = self.expectation(description: "User is authorized")
      
      var authorizationStatus: PHAuthorizationStatus?
      
      let photoManager = PhotoManager.shared
      assetManager.reset()
      assetManager.authorizationStatus = PHAuthorizationStatus.denied
      photoManager.configure(assetManager: assetManager)
      
      photoManager.requestAccessToPhotos { status in
        authorizationStatus = status
        expectation.fulfill()
      }
      
      waitForExpectations(timeout: 1, handler: nil)
      XCTAssertEqual(authorizationStatus, PHAuthorizationStatus.denied, "Request for access to user photos was not denied")
    }
    
    func testNotDeterminedAuthorization() {
      let expectation = self.expectation(description: "User is authorized")
      
      var authorizationStatus: PHAuthorizationStatus?
      
      let photoManager = PhotoManager.shared
      assetManager.reset()
      assetManager.authorizationStatus = PHAuthorizationStatus.notDetermined
      photoManager.configure(assetManager: assetManager)
      
      photoManager.requestAccessToPhotos { status in
        authorizationStatus = status
        expectation.fulfill()
      }
      
      waitForExpectations(timeout: 1, handler: nil)
      XCTAssertEqual(authorizationStatus, PHAuthorizationStatus.notDetermined, "Request for access to user photos was not denied")
    }
    
    func testRestrictedAuthorization() {
      let expectation = self.expectation(description: "User is authorized")
      
      var authorizationStatus: PHAuthorizationStatus?
      
      let photoManager = PhotoManager.shared
      assetManager.reset()
      assetManager.authorizationStatus = PHAuthorizationStatus.restricted
      photoManager.configure(assetManager: assetManager)
      
      photoManager.requestAccessToPhotos { status in
        authorizationStatus = status
        expectation.fulfill()
      }
      
      waitForExpectations(timeout: 1, handler: nil)
      XCTAssertEqual(authorizationStatus, PHAuthorizationStatus.restricted, "Request for access to user photos was not restricted")
    }

}
