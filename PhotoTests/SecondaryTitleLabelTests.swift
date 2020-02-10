//
//  SecondaryTitleLabelTests.swift
//  PhotoTests
//
//  Created by Taylor Maxwell on 2/7/20.
//  Copyright © 2020 Taylor Maxwell. All rights reserved.
//

import Foundation

import XCTest
@testable import Photo

class SecondaryTitleLabelTests: XCTestCase {
  
  func testValidSecondaryTitleLabelCreated() {
    
    let alignment = NSTextAlignment.center
    let fontSize: CGFloat = 10
    let secondaryTitleLabel = SecondaryTitleLabel(textAlignment: alignment, fontSize: fontSize)
    XCTAssertNotNil(secondaryTitleLabel, "TitleLabel instance could not be created")
    XCTAssertEqual(secondaryTitleLabel.textAlignment, alignment, "TitleLabel did not keep the passed text alignment")
    
    let expectedTextColor = UIColor.secondaryLabel
    XCTAssertEqual(secondaryTitleLabel.textColor, expectedTextColor,
                   "TitleLabel textColor property has changed from expected \(expectedTextColor.description)")
    XCTAssertTrue(secondaryTitleLabel.adjustsFontSizeToFitWidth, "TitleLabel adjustsFontSizeToFitWidth is not true")
    
    let expectedMinimumScaleFactor: CGFloat = 0.90
    let actualMiniumScaleFactor: CGFloat = secondaryTitleLabel.minimumScaleFactor
    XCTAssertTrue(abs(actualMiniumScaleFactor - expectedMinimumScaleFactor) < 0.01,
                  "TitleLabel minimumScaleFactor is not set to \(expectedMinimumScaleFactor)")
    
    let expectedLineBreakMode = NSLineBreakMode.byTruncatingTail
    XCTAssertEqual(secondaryTitleLabel.lineBreakMode, expectedLineBreakMode)
    XCTAssertFalse(secondaryTitleLabel.translatesAutoresizingMaskIntoConstraints)
  }
  
}
