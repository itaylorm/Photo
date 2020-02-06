//
//  IMImageViewTests.swift
//  PhotoTests
//
//  Created by Taylor Maxwell on 2/5/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import XCTest
@testable import Photo

class IMPhotoImageViewTests: XCTestCase {

    func testIMPhotoImageViewCreate() {
        let imageView = IMPhotoImageView(frame: .zero)
        let expectedContentMode = UIView.ContentMode.scaleAspectFill
        XCTAssertEqual(imageView.contentMode, expectedContentMode, "IMImageView is \(imageView.contentMode) expected \(expectedContentMode)")
        XCTAssertTrue(imageView.clipsToBounds, "IMImageView clipsToBounds is not true")
        XCTAssertFalse(imageView.translatesAutoresizingMaskIntoConstraints, "IMImageView is not true")
    }

}
