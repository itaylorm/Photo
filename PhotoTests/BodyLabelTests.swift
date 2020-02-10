//
//  IMBodyLabelTests.swift
//  PhotoTests
//
//  Created by Taylor Maxwell on 2/5/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import XCTest
@testable import Photo

class BodyLabelTests: XCTestCase {
  
  func testValidBodyLabelCreated() {
    
    let alignment = NSTextAlignment.left
    let bodyLabel = BodyLabel(textAlignment: alignment)
    XCTAssertNotNil(bodyLabel, "BodyLabel instance could not be created")
    XCTAssertEqual(bodyLabel.textAlignment, alignment, "BodyLabel did not keep the passed text alignment")
    
    let expectedTextColor = UIColor.secondaryLabel
    XCTAssertEqual(bodyLabel.textColor, expectedTextColor,
                   "BodyLabel textColor property has changed from expected \(expectedTextColor.description)")
    XCTAssertTrue(bodyLabel.adjustsFontSizeToFitWidth, "BodyLabel adjustsFontSizeToFitWidth is not true")
    
    let expectedMinimumScaleFactor: CGFloat = 0.75
    let actualMiniumScaleFactor: CGFloat = bodyLabel.minimumScaleFactor
    XCTAssertTrue(abs(actualMiniumScaleFactor - expectedMinimumScaleFactor) < 0.01,
                  "BodyLabel minimumScaleFactor is not set to \(expectedMinimumScaleFactor)")
    
    let expectedLineBreakMode = NSLineBreakMode.byWordWrapping
    XCTAssertEqual(bodyLabel.lineBreakMode, expectedLineBreakMode)
    XCTAssertFalse(bodyLabel.translatesAutoresizingMaskIntoConstraints)
  }
  
}
