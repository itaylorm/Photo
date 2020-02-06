//
//  IMImageViewTests.swift
//  PhotoTests
//
//  Created by Taylor Maxwell on 2/5/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import XCTest
@testable import Photo

class PhotoImageViewTests: XCTestCase {

    func testValidPhotoImageViewCreate() {
        let imageView = IMPhotoImageView(frame: .zero)
        let expectedContentMode = UIView.ContentMode.scaleAspectFill
        XCTAssertEqual(imageView.contentMode, expectedContentMode, "ImageView is \(imageView.contentMode) expected \(expectedContentMode)")
        XCTAssertTrue(imageView.clipsToBounds, "ImageView clipsToBounds is not true")
        XCTAssertFalse(imageView.translatesAutoresizingMaskIntoConstraints, "ImageView is not true")
    }

}
